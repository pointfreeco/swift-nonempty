extension NonEmpty where C: RangeReplaceableCollection {
  public init(_ head: Element, _ tail: Element...) {
    self.init(head, C(tail))
  }

  public mutating func append(_ newElement: Element) {
    self.tail.append(newElement)
  }

  public mutating func append<S: Sequence>(contentsOf newElements: S) where Element == S.Element {
    self.tail.append(contentsOf: newElements)
  }

  public mutating func insert(_ newElement: Element, at i: Index) {
    switch i {
    case .head:
      self.tail.insert(self.head, at: self.tail.startIndex)
      self.head = newElement
    case let .tail(index):
      self.tail.insert(newElement, at: self.tail.index(after: index))
    }
  }

  public mutating func insert<S>(contentsOf newElements: S, at i: Index)
    where S: Collection, Element == S.Element {

      switch i {
      case .head:
        guard let first = newElements.first else { return }
        var tail = C(newElements.dropFirst())
        tail.append(self.head)
        self.tail.insert(contentsOf: tail, at: self.tail.startIndex)
        self.head = first
      case let .tail(index):
        self.tail.insert(contentsOf: newElements, at: self.tail.index(after: index))
      }
  }

  public static func + <S: Sequence>(lhs: NonEmpty, rhs: S) -> NonEmpty where Element == S.Element {
    var tail = lhs.tail
    tail.append(contentsOf: rhs)
    return NonEmpty(lhs.head, tail)
  }

  public static func += <S: Sequence>(lhs: inout NonEmpty, rhs: S) where Element == S.Element {
    lhs.append(contentsOf: rhs)
  }
}

extension NonEmpty where C: RangeReplaceableCollection, C.Index == Int {
  public mutating func insert(_ newElement: Element, at i: Int) {
    self.insert(newElement, at: i == self.tail.startIndex ? .head : .tail(i - 1))
  }

  public mutating func insert<S>(contentsOf newElements: S, at i: Int)
    where S: Collection, Element == S.Element {

      self.insert(contentsOf: newElements, at: i == self.tail.startIndex ? .head : .tail(i - 1))
  }
}

extension NonEmpty {
  public func joined<S: Sequence, RRC: RangeReplaceableCollection>(
    separator: S
    )
    -> NonEmpty<RRC>
    where Element == NonEmpty<RRC>, S.Element == RRC.Element {

      return NonEmpty<RRC>(
        self.head.head, self.head.tail + RRC(separator) + RRC(self.tail.joined(separator: separator))
      )
  }

  public func joined<RRC: RangeReplaceableCollection>() -> NonEmpty<RRC> where Element == NonEmpty<RRC> {
      return joined(separator: RRC())
  }
}
