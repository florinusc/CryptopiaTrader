import UIKit

open class PagingView: UIView {
  
  open let pageView: UIView
  open let collectionView: UICollectionView
  open let options: PagingOptions
  
  public init(pageView: UIView, collectionView: UICollectionView, options: PagingOptions) {
    
    self.pageView = pageView
    self.collectionView = collectionView
    self.options = options
    
    super.init(frame: .zero)
    
    configure()
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open func configure() {
    collectionView.backgroundColor = options.theme.headerBackgroundColor
    addSubview(pageView)
    addSubview(collectionView)
    setupConstraints()
  }
  
  open func setupConstraints() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    pageView.translatesAutoresizingMaskIntoConstraints = false
    
    let metrics = [
      "height": options.menuHeight]
    
    let views = [
      "collectionView": collectionView,
      "pageView": pageView]
    
    let horizontalCollectionViewContraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[collectionView]|",
      options: NSLayoutFormatOptions(),
      metrics: metrics,
      views: views)
    
    let horizontalPagingContentViewContraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[pageView]|",
      options: NSLayoutFormatOptions(),
      metrics: metrics,
      views: views)
    
    let verticalContraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|[collectionView(==height)][pageView]|",
      options: NSLayoutFormatOptions(),
      metrics: metrics,
      views: views)
    
    addConstraints(horizontalCollectionViewContraints)
    addConstraints(horizontalPagingContentViewContraints)
    addConstraints(verticalContraints)
  }
  
}
