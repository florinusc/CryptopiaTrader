import Foundation

enum PagingEvent<T: PagingItem> where T: Equatable {
  case scroll(progress: CGFloat)
  case select(pagingItem: T, direction: PagingDirection, animated: Bool)
  case finishScrolling
  case cancelScrolling
}

extension PagingEvent {
  
  var animated: Bool? {
    switch self {
    case let .select(_, _, animated):
      return animated
    default:
      return nil
    }
  }
  
}
