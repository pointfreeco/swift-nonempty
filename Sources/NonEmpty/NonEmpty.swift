@dynamicMemberLookup
public struct NonEmpty<Collection: Swift.Collection>: Swift.Collection {
  public typealias Element = Collection.Element
  public typealias Index = Collection.Index

  public internal(set) var tail: Slice<Collection>

  public init(from rawValue: Collection) throws {
    guard !rawValue.isEmpty else {
      throw Self.Error.emptyCollection
    }
    self.tail = Slice(base: rawValue, bounds: rawValue.startIndex..<rawValue.endIndex)
  }

  public init?(rawValue: Collection) {
    try? self.init(from: rawValue)
  }

  public subscript<Subject>(dynamicMember keyPath: KeyPath<Collection, Subject>) -> Subject {
    self.tail.base[keyPath: keyPath]
  }

  public var startIndex: Index { self.tail.startIndex }

  public var endIndex: Index { self.tail.endIndex }

  public subscript(position: Index) -> Element { self.tail[position] }

  public func index(after i: Index) -> Index {
    self.tail.index(after: i)
  }

  public var first: Element { self.tail.first! }

  public func max(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element {
    try self.tail.max(by: areInIncreasingOrder)!
  }

  public func min(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> Element {
    try self.tail.min(by: areInIncreasingOrder)!
  }

  public func sorted(
    by areInIncreasingOrder: (Element, Element) throws -> Bool
  ) rethrows -> NonEmpty<[Element]> {
    NonEmpty<[Element]>(rawValue: try self.tail.sorted(by: areInIncreasingOrder))!
  }

  public func randomElement<T>(using generator: inout T) -> Element where T: RandomNumberGenerator {
    self.tail.randomElement(using: &generator)!
  }

  public func randomElement() -> Element {
    self.tail.randomElement()!
  }

  public func shuffled<T>(using generator: inout T) -> NonEmpty<[Element]>
  where T: RandomNumberGenerator {
    NonEmpty<[Element]>(rawValue: self.tail.shuffled(using: &generator))!
  }

  public func shuffled() -> NonEmpty<[Element]> {
    NonEmpty<[Element]>(rawValue: self.tail.shuffled())!
  }

  public func map<T>(_ transform: (Element) throws -> T) rethrows -> NonEmpty<[T]> {
    NonEmpty<[T]>(rawValue: try self.tail.map(transform))!
  }

  public func flatMap<SegmentOfResult>(
    _ transform: (Element) throws -> NonEmpty<SegmentOfResult>
  ) rethrows -> NonEmpty<[SegmentOfResult.Element]> where SegmentOfResult: Sequence {
    NonEmpty<[SegmentOfResult.Element]>(rawValue: try self.tail.flatMap(transform))!
  }
}

extension NonEmpty: CustomStringConvertible {
  public var description: String {
    return String(describing: self.tail)
  }
}

extension NonEmpty: Equatable where Collection: Equatable {
  public static func == (lhs: NonEmpty<Collection>, rhs: NonEmpty<Collection>) -> Bool {
    lhs.tail.base == rhs.tail.base
  }
}

extension NonEmpty: Hashable where Collection: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.tail.base)
  }
}

extension NonEmpty: Comparable where Collection: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.tail.base < rhs.tail.base
  }
}

extension NonEmpty: Encodable where Collection: Encodable {
  public func encode(to encoder: Encoder) throws {
    try self.tail.base.encode(to: encoder)
  }
}

extension NonEmpty: Decodable where Collection: Decodable {
  public init(from decoder: Decoder) throws {
    let collection = try Collection(from: decoder)
    guard !collection.isEmpty else {
      throw DecodingError.dataCorrupted(
        .init(codingPath: decoder.codingPath, debugDescription: "Non-empty collection expected")
      )
    }
    self.init(rawValue: collection)!
  }
}

extension NonEmpty: RawRepresentable {
  public internal(set) var rawValue: Collection {
    get { tail.base }
    set { tail = Slice(base: newValue, bounds: newValue.startIndex..<newValue.endIndex) }
  }
}

extension NonEmpty where Collection.Element: Comparable {
  public func max() -> Element {
    self.tail.max()!
  }

  public func min() -> Element {
    self.tail.min()!
  }

  public func sorted() -> NonEmpty<[Element]> {
    return NonEmpty<[Element]>(rawValue: self.tail.sorted())!
  }
}

extension NonEmpty: BidirectionalCollection where Collection: BidirectionalCollection {
  public func index(before i: Index) -> Index {
    self.tail.index(before: i)
  }

  public var last: Element { self.tail.last! }
}

extension NonEmpty: MutableCollection where Collection: MutableCollection {
  public subscript(position: Index) -> Element {
    _read { yield self.tail[position] }
    _modify { yield &self.tail[position] }
  }
}

extension NonEmpty: RandomAccessCollection where Collection: RandomAccessCollection {}

extension NonEmpty where Collection: MutableCollection & RandomAccessCollection {
  public mutating func shuffle<T: RandomNumberGenerator>(using generator: inout T) {
    self.tail.shuffle(using: &generator)
  }
}

public typealias NonEmptyArray<Element> = NonEmpty<[Element]>
