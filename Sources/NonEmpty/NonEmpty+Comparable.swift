extension NonEmpty: Comparable where C: Comparable, C.Element: Comparable {
  public static func < (lhs: NonEmpty, rhs: NonEmpty) -> Bool {
    return lhs.head < rhs.head && lhs.tail < rhs.tail
  }
}

extension NonEmpty where C.Element: Comparable {
  public func max() -> Element {
    return Swift.max(self.head, self.tail.max() ?? self.head)
  }

  public func min() -> Element {
    return Swift.min(self.head, self.tail.min() ?? self.head)
  }

  public func sorted() -> NonEmpty<[Element]> {
    var result = ContiguousArray(self)
    result.sort()
    return NonEmpty<[Element]>(result.first ?? self.head, Array(result.dropFirst()))
  }
}
