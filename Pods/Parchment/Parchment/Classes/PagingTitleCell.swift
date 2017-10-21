import UIKit

open class PagingTitleCell: PagingCell {
  
  fileprivate var viewModel: PagingTitleCellViewModel?
  fileprivate let titleLabel = UILabel(frame: .zero)
  
  open override var isSelected: Bool {
    didSet {
      configureTitleLabel()
    }
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  open override func setPagingItem(_ pagingItem: PagingItem, selected: Bool, theme: PagingTheme) {
    if let titleItem = pagingItem as? PagingTitleItem {
      viewModel = PagingTitleCellViewModel(
        title: titleItem.title,
        selected: selected,
        theme: theme)
    }
    configureTitleLabel()
  }
  
  open func configure() {
    contentView.addSubview(titleLabel)
    contentView.constrainToEdges(titleLabel)
  }
  
  open func configureTitleLabel() {
    guard let viewModel = viewModel else { return }
    titleLabel.text = viewModel.title
    titleLabel.font = viewModel.font
    titleLabel.textAlignment = .center
    
    if viewModel.selected {
      titleLabel.textColor = viewModel.selectedTextColor
    } else {
      titleLabel.textColor = viewModel.textColor
    }
  }
  
  open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    super.apply(layoutAttributes)
    guard let viewModel = viewModel else { return }
    if let attributes = layoutAttributes as? PagingCellLayoutAttributes {
      titleLabel.textColor = UIColor.interpolate(
        from: viewModel.textColor,
        to: viewModel.selectedTextColor,
        with: attributes.progress)
    }
  }
  
}
