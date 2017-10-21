import UIKit

open class PagingInvalidationContext: UICollectionViewLayoutInvalidationContext {
  var invalidateContentOffset: Bool = false
  var invalidateTransition: Bool = false
}

