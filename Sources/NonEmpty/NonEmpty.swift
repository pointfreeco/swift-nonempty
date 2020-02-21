@dynamicMemberLookup
public struct NonEmpty<C> {
  fileprivate var rawValue: C

  public subscript<Subject>(dynamicMember keyPath: KeyPath<C, Subject>) -> Subject {
    self.rawValue[keyPath: keyPath]
  }
}

extension NonEmpty: CustomStringConvertible {
  public var description: String {
    return String(describing: self.rawValue)
  }
}

extension NonEmpty: Equatable where C: Equatable {}

extension NonEmpty: Hashable where C: Hashable {}

extension NonEmpty: Comparable where C: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension NonEmpty: Encodable where C: Collection & Encodable {
  public func encode(to encoder: Encoder) throws {
    try self.rawValue.encode(to: encoder)
  }
}

extension NonEmpty: Decodable where C: Collection & Decodable {
  public init(from decoder: Decoder) throws {
    let collection = try C(from: decoder)
    guard !collection.isEmpty else {
      throw DecodingError.dataCorrupted(
        .init(codingPath: decoder.codingPath, debugDescription: "Non-empty collection expected")
      )
    }
    self.init(collection)!
  }
}

extension NonEmpty: Sequence where C: Sequence {
  public typealias Element = C.Element
  public typealias Iterator = C.Iterator

  public func makeIterator() -> Iterator {
    self.rawValue.makeIterator()
  }
}

extension NonEmpty: Collection where C: Collection {
  public typealias Index = C.Index

  public init?(_ collection: C) {
    guard !collection.isEmpty else { return nil }
    self.rawValue = collection
  }

  public var startIndex: Index { self.rawValue.startIndex }

  public var endIndex: Index { self.rawValue.endIndex }

  public subscript(position: Index) -> Element { self.rawValue[position] }

  public func index(after i: Index) -> Index {
    self.rawValue.index(after: i)
  }

  public var first: Element { self.rawValue.first! }

  public func max(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element {
    try self.rawValue.max(by: areInIncreasingOrder)!
  }

  public func min(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element {
    try self.rawValue.min(by: areInIncreasingOrder)!
  }

  public func sorted(
    by areInIncreasingOrder: (Element, Element) throws -> Bool
  ) rethrows -> NonEmpty<[Element]> {
    NonEmpty<[Element]>(try self.rawValue.sorted(by: areInIncreasingOrder))!
  }

  public func randomElement<T>(using generator: inout T) -> Element where T: RandomNumberGenerator {
    self.rawValue.randomElement(using: &generator)!
  }

  public func randomElement() -> Element {
    self.rawValue.randomElement()!
  }

  public func shuffled<T>(using generator: inout T) -> NonEmpty<[Element]> where T: RandomNumberGenerator {
    NonEmpty<[Element]>(self.rawValue.shuffled(using: &generator))!
  }

  public func shuffled() -> NonEmpty<[Element]> {
    NonEmpty<[Element]>(self.rawValue.shuffled())!
  }

  public func map<T>(_ transform: (Element) throws -> T) rethrows -> NonEmpty<[T]> {
    NonEmpty<[T]>(try self.rawValue.map(transform))!
  }

  public func flatMap<SegmentOfResult>(
    _ transform: (Element) throws -> NonEmpty<SegmentOfResult>
  ) rethrows -> NonEmpty<[SegmentOfResult.Element]> where SegmentOfResult: Sequence {
    NonEmpty<[SegmentOfResult.Element]>(try self.rawValue.flatMap(transform))!
  }
}

extension NonEmpty where C: Collection, C.Element: Comparable {
  public func max() -> Element {
    self.rawValue.max()!
  }

  public func min() -> Element {
    self.rawValue.min()!
  }

  public func sorted() -> NonEmpty<[Element]> {
    return NonEmpty<[Element]>(self.rawValue.sorted())!
  }
}

extension NonEmpty: BidirectionalCollection where C: BidirectionalCollection {
  public func index(before i: Index) -> Index {
    self.rawValue.index(before: i)
  }

  public var last: Element { self.rawValue.last! }
}

extension NonEmpty: MutableCollection where C: MutableCollection {
  public subscript(position: Index) -> Element {
    get { self.rawValue[position] }
    set { self.rawValue[position] = newValue }
    _modify { yield &self.rawValue[position] }
  }
}

extension NonEmpty: RandomAccessCollection where C: RandomAccessCollection {}

extension NonEmpty where C: MutableCollection & RandomAccessCollection {
  public mutating func shuffle<T: RandomNumberGenerator>(using generator: inout T) {
    self.rawValue.shuffle(using: &generator)
  }
}

extension NonEmpty where C: RangeReplaceableCollection {
  public init(_ head: Element, _ tail: Element...) {
    var tail = tail
    tail.insert(head, at: tail.startIndex)
    self.init(C(tail))!
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

extension NonEmpty where C: SetAlgebra, C.Element: Hashable & Comparable {
  public init?(_ collection: C) {
    guard !collection.isEmpty else { return nil }
    self.rawValue = collection
  }

  public init(_ head: C.Element, _ tail: C.Element...) {
    var tail = C(tail)
    tail.insert(head)
    self.init(tail)!
  }

  public func contains(_ member: C.Element) -> Bool {
    self.rawValue.contains(member)
  }

  public func union(_ other: NonEmpty) -> NonEmpty {
    var copy = self
    copy.formUnion(other)
    return copy
  }

  public func union(_ other: C) -> NonEmpty {
    var copy = self
    copy.formUnion(other)
    return copy
  }

  public func intersection(_ other: NonEmpty) -> C {
    self.rawValue.intersection(other.rawValue)
  }

  public func intersection(_ other: C) -> C {
    self.rawValue.intersection(other)
  }

  public func symmetricDifference(_ other: NonEmpty) -> C {
    self.rawValue.symmetricDifference(other.rawValue)
  }

  public func symmetricDifference(_ other: C) -> C {
    self.rawValue.symmetricDifference(other)
  }

  @discardableResult
  public mutating func insert(_ newMember: C.Element) -> (inserted: Bool, memberAfterInsert: C.Element) {
    self.rawValue.insert(newMember)
  }

  @discardableResult
  public mutating func update(with newMember: C.Element) -> C.Element? {
    self.rawValue.update(with: newMember)
  }

  public mutating func formUnion(_ other: NonEmpty) {
    self.rawValue.formUnion(other.rawValue)
  }

  public mutating func formUnion(_ other: C) {
    self.rawValue.formUnion(other)
  }

  public func subtracting(_ other: NonEmpty) -> C {
    self.rawValue.subtracting(other.rawValue)
  }

  public func subtracting(_ other: C) -> C {
    self.rawValue.subtracting(other)
  }

  public func isDisjoint(with other: NonEmpty) -> Bool {
    self.rawValue.isDisjoint(with: other.rawValue)
  }

  public func isDisjoint(with other: C) -> Bool {
    self.rawValue.isDisjoint(with: other)
  }

  public func isSubset(of other: NonEmpty) -> Bool {
    self.rawValue.isSubset(of: other.rawValue)
  }

  public func isSubset(of other: C) -> Bool {
    self.rawValue.isSubset(of: other)
  }

  public func isSuperset(of other: NonEmpty) -> Bool {
    self.rawValue.isSuperset(of: other.rawValue)
  }

  public func isSuperset(of other: C) -> Bool {
    self.rawValue.isSuperset(of: other)
  }

  public func isStrictSubset(of other: NonEmpty) -> Bool {
    self.rawValue.isStrictSubset(of: other.rawValue)
  }

  public func isStrictSubset(of other: C) -> Bool {
    self.rawValue.isStrictSubset(of: other)
  }

  public func isStrictSuperset(of other: NonEmpty) -> Bool {
    self.rawValue.isStrictSuperset(of: other.rawValue)
  }

  public func isStrictSuperset(of other: C) -> Bool {
    self.rawValue.isStrictSuperset(of: other)
  }
}

extension SetAlgebra {
  // TODO: (Self, NonEmpty<C>) -> R where C.Element == Element
}

public typealias NonEmptyArray<Element> = NonEmpty<[Element]>

public typealias NonEmptyString = NonEmpty<String>

extension NonEmpty where C == String {
  public init(_ head: Character, _ tail: String) {
    var tail = tail
    tail.insert(head, at: tail.startIndex)
    self.init(tail)!
  }
}

public typealias NonEmptySet<Element> = NonEmpty<Set<Element>> where Element: Hashable
