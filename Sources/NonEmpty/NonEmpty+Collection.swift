extension NonEmpty: Collection {
  public enum Index: Comparable {
    case head
    case tail(C.Index)

    public static func < (lhs: Index, rhs: Index) -> Bool {
      switch (lhs, rhs) {
      case let (.tail(l), .tail(r)):
        return l < r
      case (.head, .tail):
        return true
      case (.tail, .head), (.head, .head):
        return false
      }
    }
  }

  public var startIndex: Index {
    return .head
  }

  public var endIndex: Index {
    return .tail(self.tail.endIndex)
  }

  public subscript(position: Index) -> Element {
    switch position {
    case .head:
      return self.head
    case let .tail(index):
      return self.tail[index]
    }
  }

  public func index(after i: Index) -> Index {
    switch i {
    case .head:
      return .tail(self.tail.startIndex)
    case let .tail(index):
      return .tail(self.tail.index(after: index))
    }
  }
}

extension NonEmpty {
  #if swift(>=4.1.5)
  public var first: Element {
    return self.head
  }

  @available(swift, obsoleted: 4.1.5, renamed: "first")
  public var safeFirst: Element {
    return self.head
  }
  #else
  public var safeFirst: Element {
    return self.head
  }
  #endif

  public func flatMap<T>(_ transform: (Element) throws -> NonEmpty<[T]>) rethrows -> NonEmpty<[T]> {
    var result = try transform(self.head)
    for element in self.tail {
      try result.append(contentsOf: transform(element))
    }
    return result
  }

  public func map<T>(_ transform: (Element) throws -> T) rethrows -> NonEmpty<[T]> {
    return try NonEmpty<[T]>(transform(self.head), self.tail.map(transform))
  }

  public func max(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element {
    return try self.tail
      .max(by: areInIncreasingOrder)
      .map { try areInIncreasingOrder(self.head, $0) ? $0 : self.head } ?? self.head
  }

  public func min(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element {
    return try self.tail
      .min(by: areInIncreasingOrder)
      .map { try areInIncreasingOrder(self.head, $0) ? self.head : $0 } ?? self.head
  }

  public func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> NonEmpty<[Element]> {
    var result = ContiguousArray(self)
    try result.sort(by: areInIncreasingOrder)
    return NonEmpty<[Element]>(result.first ?? self.head, Array(result.dropFirst()))
  }
}

extension NonEmpty where C.Index == Int {
  public subscript(position: Int) -> Element {
    return self[position == 0 ? .head : .tail(self.tail.startIndex + position - 1)]
  }
}
