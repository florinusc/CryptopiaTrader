import UIKit

class PagingBorderView: UICollectionReusableView {
  
  override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    if let attributes = layoutAttributes as? PagingBorderLayoutAttributes {
      backgroundColor = attributes.backgroundColor
    }
  }
  
}
