@dynamicMemberLookup
public struct NonEmpty<C: Collection>: Collection {
  public typealias Element = C.Element
  public typealias Index = C.Index

  public internal(set) var rawValue: C

  public init?(_ rawValue: C) {
    guard !rawValue.isEmpty else { return nil }
    self.rawValue = rawValue
  }

  public subscript<Subject>(dynamicMember keyPath: KeyPath<C, Subject>) -> Subject {
    self.rawValue[keyPath: keyPath]
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

extension NonEmpty: RawRepresentable {
  public init?(rawValue: C) {
    self.init(rawValue)
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

public typealias NonEmptyArray<Element> = NonEmpty<[Element]>

extension NonEmpty where C == String {
  public init(_ head: Character, _ tail: String) {
    var tail = tail
    tail.insert(head, at: tail.startIndex)
    self.init(tail)!
  }
}
