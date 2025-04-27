// NB: `NonEmpty` does not conditionally conform to `RangeReplaceableCollection` because it contains destructive methods.
extension NonEmpty where Collection: RangeReplaceableCollection {
  public init(_ head: Element, _ tail: Element...) {
    var tail = tail
    tail.insert(head, at: tail.startIndex)
    self = .init(rawValue: Collection(tail)).unsafelyUnwrapped
  }

  public init?<S>(_ elements: S) where S: Sequence, Collection.Element == S.Element {
    self.init(rawValue: Collection(elements))
  }

  public mutating func append(_ newElement: Element) {
    self.rawValue.append(newElement)
  }

  public mutating func append<S: Sequence>(contentsOf newElements: S) where Element == S.Element {
    self.rawValue.append(contentsOf: newElements)
  }

  public mutating func insert(_ newElement: Element, at i: Index) {
    self.rawValue.insert(newElement, at: i)
  }

  public mutating func insert<S>(
    contentsOf newElements: S, at i: Index
  ) where S: Swift.Collection, Element == S.Element {
    self.rawValue.insert(contentsOf: newElements, at: i)
  }

  public static func += <S: Sequence>(lhs: inout Self, rhs: S) where Element == S.Element {
    lhs.append(contentsOf: rhs)
  }

  public static func + (lhs: Self, rhs: Self) -> Self {
    var lhs = lhs
    lhs += rhs
    return lhs
  }

  public static func + <S: Sequence>(lhs: Self, rhs: S) -> Self where Element == S.Element {
    var lhs = lhs
    lhs += rhs
    return lhs
  }

  public static func + <S: Sequence>(lhs: S, rhs: Self) -> Self where Element == S.Element {
    var rhs = rhs
    rhs.insert(contentsOf: ContiguousArray(lhs), at: rhs.startIndex)
    return rhs
  }
}

extension NonEmpty {
  public func joined<S: Sequence, C: RangeReplaceableCollection>(
    separator: S
  )
    -> NonEmpty<C>
  where Element == NonEmpty<C>, S.Element == C.Element {
    NonEmpty<C>(rawValue: C(self.rawValue.joined(separator: separator))).unsafelyUnwrapped
  }

  public func joined<C: RangeReplaceableCollection>() -> NonEmpty<C>
  where Element == NonEmpty<C> {
    return joined(separator: C())
  }
}
