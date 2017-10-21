import Foundation

protocol PagingCollectionViewLayoutDelegate: class {
  func pagingCollectionViewLayout<T>(_ pagingCollectionViewLayout: PagingCollectionViewLayout<T>, widthForIndexPath indexPath: IndexPath) -> CGFloat
}

