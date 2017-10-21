import Foundation

struct PagingDataStructure<T: PagingItem> where T: Hashable, T: Comparable {
  
  let visibleItems: Set<T>
  let sortedItems: [T]
  let hasItemsBefore: Bool
  let hasItemsAfter: Bool
  
  init(
    visibleItems: Set<T>,
    hasItemsBefore: Bool = false,
    hasItemsAfter: Bool = false) {
    
    self.visibleItems = visibleItems
    self.sortedItems = Array(visibleItems).sorted()
    self.hasItemsBefore = hasItemsBefore
    self.hasItemsAfter = hasItemsAfter
  }
  
  func directionForIndexPath(_ indexPath: IndexPath, currentPagingItem: T) -> PagingDirection {
    guard let currentIndexPath = indexPathForPagingItem(currentPagingItem) else { return .none }
    
    if indexPath.item > currentIndexPath.item {
      return .forward
    } else if indexPath.item < currentIndexPath.item {
      return .reverse
    }
    return .none
  }
  
  func indexPathForPagingItem(_ pagingItem: T) -> IndexPath? {
    guard let index = sortedItems.index(of: pagingItem) else { return nil }
    return IndexPath(item: index, section: 0)
  }
  
  func pagingItemForIndexPath(_ indexPath: IndexPath) -> T {
    return sortedItems[indexPath.item]
  }
  
}
