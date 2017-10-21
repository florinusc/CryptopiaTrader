import UIKit

public protocol FixedPagingViewControllerDelegate : class {
  func fixedPagingViewController(fixedPagingViewController: FixedPagingViewController, willScrollToItem: ViewControllerItem, atIndex index: Int)
  func fixedPagingViewController(fixedPagingViewController: FixedPagingViewController, didScrollToItem: ViewControllerItem, atIndex index: Int)
}

open class FixedPagingViewController: PagingViewController<ViewControllerItem> {
  
  open let items: [ViewControllerItem]
  open weak var itemDelegate: FixedPagingViewControllerDelegate?
  
  public init(viewControllers: [UIViewController], options: PagingOptions = DefaultPagingOptions()) {
    
    items = viewControllers.enumerated().map {
      ViewControllerItem(viewController: $1, index: $0)
    }
    
    super.init(options: options)
    dataSource = self
    
    if let item = items.first {
      selectPagingItem(item)
    }
  }

  required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  // MARK: EMPageViewControllerDelegate
  
  open override func em_pageViewController(_ pageViewController: EMPageViewController, didFinishScrollingFrom startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
    super.em_pageViewController(pageViewController, didFinishScrollingFrom: startingViewController, destinationViewController: destinationViewController, transitionSuccessful: transitionSuccessful)
    
    if let index = items.index(where: { $0.viewController == destinationViewController }) {
      itemDelegate?.fixedPagingViewController(
        fixedPagingViewController: self,
        didScrollToItem: items[index],
        atIndex: index)
    }
  }
  
  public func em_pageViewController(_ pageViewController: EMPageViewController, willStartScrollingFrom startingViewController: UIViewController, destinationViewController: UIViewController) {
    if let index = items.index(where: { $0.viewController == destinationViewController }) {
      itemDelegate?.fixedPagingViewController(
        fixedPagingViewController: self,
        willScrollToItem: items[index],
        atIndex: index)
    }
  }
  
}

extension FixedPagingViewController: PagingViewControllerDataSource {
  
  public func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForPagingItem pagingItem: T) -> UIViewController {
    let index = items.index(of: pagingItem as! ViewControllerItem)!
    return items[index].viewController
  }
  
  public func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemBeforePagingItem pagingItem: T) -> T? {
    guard let index = items.index(of: pagingItem as! ViewControllerItem) else { return nil }
    if index > 0 {
      return items[index - 1] as? T
    }
    return nil
  }
  
  public func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemAfterPagingItem pagingItem: T) -> T? {
    guard let index = items.index(of: pagingItem as! ViewControllerItem) else { return nil }
    if index < items.count - 1 {
      return items[index + 1] as? T
    }
    return nil
  }
  
}
