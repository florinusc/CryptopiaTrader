import UIKit

class PagingBorderLayoutAttributes: UICollectionViewLayoutAttributes {
  
  var backgroundColor: UIColor?
  var insets: UIEdgeInsets = UIEdgeInsets()
  
  func configure(_ options: PagingOptions) {
    if case let .visible(height, index, borderInsets) = options.borderOptions {
      insets = borderInsets
      backgroundColor = options.theme.borderColor
      frame.origin.x = insets.left
      frame.origin.y = options.menuHeight - height
      frame.size.height = height
      zIndex = index
    }
  }
  
  func update(contentSize: CGSize, bounds: CGRect) {
    let width = max(bounds.width, contentSize.width)
    frame.size.width = width - insets.left - insets.right
  }
  
}
