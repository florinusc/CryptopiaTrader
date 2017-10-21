import Foundation

protocol PagingStateMachineDelegate: class {
  func pagingStateMachine<T>(_ pagingStateMachine: PagingStateMachine<T>, pagingItemBeforePagingItem: T) -> T?
  func pagingStateMachine<T>(_ pagingStateMachine: PagingStateMachine<T>, pagingItemAfterPagingItem: T) -> T?
}

class PagingStateMachine<T: PagingItem> where T: Equatable {
  
  weak var delegate: PagingStateMachineDelegate?
  
  var didSelectPagingItem: ((T, PagingDirection, Bool) -> Void)?
  var didChangeState: ((PagingState<T>, PagingState<T>, PagingEvent<T>?) -> Void)?
  
  fileprivate(set) var state: PagingState<T>
  
  init(initialState: PagingState<T>) {
    self.state = initialState
  }
  
  func fire(_ event: PagingEvent<T>) {
    switch event {
    case let .scroll(progress):
      handleScrollEvent(
        event,
        progress: progress)
    case let .select(pagingItem, direction, animated):
      handleSelectEvent(
        event,
        selectedPagingItem: pagingItem,
        direction: direction,
        animated: animated)
    case .finishScrolling:
      handleFinishScrollingEvent(event)
    case .cancelScrolling:
      handleCancelScrollingEvent(event)
    }
  }
  
  fileprivate func handleScrollEvent(_ event: PagingEvent<T>, progress: CGFloat) {
    
    let oldState = state
    
    switch state {
    case let .scrolling(pagingItem, upcomingPagingItem, oldProgress):
      if oldProgress < 0 && progress > 0 {
        state = .selected(pagingItem: pagingItem)
      } else if oldProgress > 0 && progress < 0 {
        state = .selected(pagingItem: pagingItem)
      } else if progress == 0 {
        state = .selected(pagingItem: pagingItem)
      } else {
        state = .scrolling(
          pagingItem: pagingItem,
          upcomingPagingItem: upcomingPagingItem,
          progress: progress)
        
        didChangeState?(oldState, state, event)
      }
    case let .selected(pagingItem):
      if progress > 0 {
        
        let upcomingPagingItem = delegate?.pagingStateMachine(self, pagingItemAfterPagingItem: pagingItem)
        
        state = .scrolling(
          pagingItem: pagingItem,
          upcomingPagingItem: upcomingPagingItem,
          progress: progress)
        
        didChangeState?(oldState, state, event)
      } else if progress < 0 {
        
        let upcomingPagingItem = delegate?.pagingStateMachine(self, pagingItemBeforePagingItem: pagingItem)
        
        state = .scrolling(
          pagingItem: pagingItem,
          upcomingPagingItem: upcomingPagingItem,
          progress: progress)
      }
      
      didChangeState?(oldState, state, event)
    }
    
  }
  
  fileprivate func handleSelectEvent(_ event: PagingEvent<T>, selectedPagingItem: T, direction: PagingDirection, animated: Bool) {
    
    let oldState = state
    
    if selectedPagingItem != state.currentPagingItem {
      if case .selected = state {
        state = .scrolling(
          pagingItem: state.currentPagingItem,
          upcomingPagingItem: selectedPagingItem,
          progress: 0)
        
        didSelectPagingItem?(selectedPagingItem, direction, animated)
        didChangeState?(oldState, state, event)
      }
    }
  }
  
  fileprivate func handleFinishScrollingEvent(_ event: PagingEvent<T>) {
    let oldState = state
    switch state {
    case let .scrolling(currentPagingItem, upcomingPagingItem, _):
      state = .selected(pagingItem: upcomingPagingItem ?? currentPagingItem)
      didChangeState?(oldState, state, event)
    case .selected:
      break
    }
  }
  
  fileprivate func handleCancelScrollingEvent(_ event: PagingEvent<T>) {
    let oldState = state
    switch state {
    case let .scrolling(currentPagingItem, _, _):
      state = .selected(pagingItem: currentPagingItem)
      didChangeState?(oldState, state, event)
    case .selected:
      break
    }
  }
  
}
