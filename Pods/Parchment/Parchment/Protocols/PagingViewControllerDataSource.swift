import UIKit

public protocol PagingViewControllerDataSource: class {
                                                    
  /// Return the view controller accociated with the PagingItem. This
  /// method is only called for the currently selected PagingItem, and
  /// its two possible siblings.
  func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForPagingItem: T) -> UIViewController

  /// View controllers coming "before" will appear to the left of the
  /// currently selected view controller, those coming "after" would be
  /// to the right. Return "nil" to indicate that no more progress can be
  /// made in the given direction. In order for these methods to be
  /// called, you first need to set the initial paging item by calling
  /// "selectPagingItem:" on PagingViewController
  func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemBeforePagingItem: T) -> T?
  func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemAfterPagingItem: T) -> T?
}
