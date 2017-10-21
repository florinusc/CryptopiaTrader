import UIKit

/// Used to represent what to invalidate in a collection view
/// layout. We need to be able to invalidate the layout multiple times
/// with different invalidation contexts before `invalidateLayout` is
/// called and we can use we can use this to determine exactly how
/// much we need to invalidate by adding together the summaries each
/// time a new context is invalidated.

enum InvalidationSummary {
  case partial
  case everything
  case dataSourceCounts
  case contentOffset
  case transition
  
  init(_ invalidationContext: UICollectionViewLayoutInvalidationContext) {
    if invalidationContext.invalidateEverything {
      self = .everything
    } else if invalidationContext.invalidateDataSourceCounts {
      self = .dataSourceCounts
    } else if let context = invalidationContext as? PagingInvalidationContext {
      if context.invalidateTransition {
        self = .transition
      } else if context.invalidateContentOffset {
        self = .contentOffset
      } else {
        self = .partial
      }
    } else {
      self = .partial
    }
  }
  
  static func +(lhs: InvalidationSummary, rhs: InvalidationSummary) -> InvalidationSummary {
    switch (lhs, rhs) {
    case (.everything, _), (_, .everything):
      return .everything
    case (.dataSourceCounts, .dataSourceCounts):
      return .everything
    case (.dataSourceCounts, _), (_, .dataSourceCounts):
      return .dataSourceCounts
    case (.transition, _), (_, .transition):
      return .transition
    case (.contentOffset, _), (_, .contentOffset):
      return .contentOffset
    case (.partial, _), (_, .partial):
      return .partial
    default:
      return .everything
    }
  }
}

