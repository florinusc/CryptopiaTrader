import Foundation

public protocol PagingViewControllerDelegate: class {
  func pagingViewController<T>(_ pagingViewController: PagingViewController<T>,
                            widthForPagingItem pagingItem: T) -> CGFloat
}
