// NB: `NonEmpty` does not conditionally conform to `RangeReplaceableCollection` because it contains destructive methods.
extension NonEmpty where C: RangeReplaceableCollection {
  public init(_ head: Element, _ tail: Element...) {
    var tail = tail
    tail.insert(head, at: tail.startIndex)
    self.init(rawValue: C(tail))!
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
  ) where S: Collection, Element == S.Element {
    self.rawValue.insert(contentsOf: newElements, at: i)
  }

  public static func += <S: Sequence>(lhs: inout NonEmpty, rhs: S) where Element == S.Element {
    lhs.append(contentsOf: rhs)
  }

  public static func + <S: Sequence>(lhs: NonEmpty, rhs: S) -> NonEmpty where Element == S.Element {
    var lhs = lhs
    lhs += rhs
    return lhs
  }

  public static func + <S: Sequence>(lhs: S, rhs: NonEmpty) -> NonEmpty where Element == S.Element {
    var rhs = rhs
    rhs.insert(contentsOf: ContiguousArray(lhs), at: rhs.startIndex)
    return rhs
  }
}

//extension NonEmpty {
//  public func joined<S: Sequence, RRC: RangeReplaceableCollection>(
//    separator: S
//  )
//    -> NonEmpty<RRC>
//    where Element == NonEmpty<RRC>, S.Element == RRC.Element {
//
//      return NonEmpty<RRC>(
//        self.head.head, self.head.tail + RRC(separator) + RRC(self.tail.joined(separator: separator))
//      )
//  }
//
//  public func joined<RRC: RangeReplaceableCollection>() -> NonEmpty<RRC> where Element == NonEmpty<RRC> {
//    return joined(separator: RRC())
//  }
//}
