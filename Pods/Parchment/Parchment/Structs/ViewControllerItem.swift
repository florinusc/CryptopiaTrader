import UIKit

public struct ViewControllerItem: PagingTitleItem, Equatable, Hashable, Comparable {
  
  public let viewController: UIViewController
  public let title: String
  fileprivate let index: Int
  
  public var hashValue: Int {
    return viewController.hashValue
  }
  
  init(viewController: UIViewController, index: Int) {
    self.viewController = viewController
    self.title = viewController.title ?? ""
    self.index = index
  }
}

public func ==(lhs: ViewControllerItem, rhs: ViewControllerItem) -> Bool {
  return lhs.viewController == rhs.viewController
}

public func <(lhs: ViewControllerItem, rhs: ViewControllerItem) -> Bool {
  return lhs.index < rhs.index
}

