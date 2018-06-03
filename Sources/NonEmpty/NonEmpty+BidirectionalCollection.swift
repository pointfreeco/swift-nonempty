extension NonEmpty: BidirectionalCollection where C: BidirectionalCollection {
  public func index(before i: Index) -> Index {
    switch i {
    case .head:
      return .tail(self.tail.index(before: self.tail.startIndex))
    case let .tail(index):
      return index == tail.startIndex ? .head : .tail(tail.index(before: index))
    }
  }
}

extension NonEmpty where C: BidirectionalCollection {
  #if swift(>=4.1.5)
  public var last: Element {
    return self.tail.last ?? self.head
  }

  @available(swift, obsoleted: 4.1.5, renamed: "last")
  public var safeLast: Element {
    return self.tail.last ?? self.head
  }
  #else
  public var safeLast: Element {
    return self.tail.last ?? self.head
  }
  #endif
}
