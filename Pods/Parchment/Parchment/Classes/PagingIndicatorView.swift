import UIKit

class PagingIndicatorView: UICollectionReusableView {
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    if let attributes = layoutAttributes as? PagingIndicatorLayoutAttributes {
      backgroundColor = attributes.backgroundColor
    }
  }
  
}
