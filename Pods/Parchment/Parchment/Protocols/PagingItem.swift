import Foundation

public protocol PagingItem {}

public protocol PagingTitleItem: PagingItem {
  var title: String { get }
}
