import Foundation

struct PagingDiff<T: PagingItem> where T: Hashable, T: Comparable {
  
  fileprivate let from: PagingDataStructure<T>
  fileprivate let to: PagingDataStructure<T>
  fileprivate var fromCache: [Int: T]
  fileprivate var toCache: [Int: T]
  fileprivate var lastMatchingItem: T?
  
  init(from: PagingDataStructure<T>, to: PagingDataStructure<T>) {
    self.from = from
    self.to = to
    self.fromCache = [:]
    self.toCache = [:]
    
    for item in from.sortedItems {
      fromCache[item.hashValue] = item
    }
    
    for item in to.sortedItems {
      toCache[item.hashValue] = item
    }
    
    for toItem in to.sortedItems {
      for fromItem in from.sortedItems {
        if toItem == fromItem {
          lastMatchingItem = toItem
          break
        }
      }
    }
  }
  
  func removed() -> [IndexPath] {
    let removed = diff(dataStructure: from, cache: toCache)
    var items: [IndexPath] = []
    
    if let lastItem = lastMatchingItem {
      for indexPath in removed {
        if let lastIndexPath = from.indexPathForPagingItem(lastItem) {
          if indexPath.item < lastIndexPath.item {
            items.append(indexPath)
          }
        }
      }
    }
    
    return items
  }
  
  func added() -> [IndexPath] {
    let removedCount = removed().count
    let added = diff(dataStructure: to, cache: fromCache)
    
    var items: [IndexPath] = []
    
    if let lastItem = lastMatchingItem {
      for indexPath in added {
        if let lastIndexPath = from.indexPathForPagingItem(lastItem) {
          if indexPath.item + removedCount <= lastIndexPath.item {
            items.append(indexPath)
          }
        }
      }
    }
    
    return items
  }
  
  fileprivate func diff(dataStructure: PagingDataStructure<T>, cache: [Int: T]) -> [IndexPath] {
    return dataStructure.sortedItems.flatMap { item in
      if cache[item.hashValue] == nil {
        return dataStructure.indexPathForPagingItem(item)
      }
      return nil
    }
  }
  
}

