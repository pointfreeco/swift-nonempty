@dynamicMemberLookup
public struct NonEmpty<Collection: Swift.Collection>: Swift.Collection {
  public typealias Element = Collection.Element
  public typealias Index = Collection.Index

  public internal(set) var rawValue: Collection

  public init?(rawValue: Collection) {
    guard !rawValue.isEmpty else { return nil }
    self.rawValue = rawValue
  }

  public subscript<Subject>(dynamicMember keyPath: KeyPath<Collection, Subject>) -> Subject {
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
    NonEmpty<[Element]>(rawValue: try self.rawValue.sorted(by: areInIncreasingOrder))!
  }

  public func randomElement<T>(using generator: inout T) -> Element where T: RandomNumberGenerator {
    self.rawValue.randomElement(using: &generator)!
  }

  public func randomElement() -> Element {
    self.rawValue.randomElement()!
  }

  public func shuffled<T>(using generator: inout T) -> NonEmpty<[Element]>
  where T: RandomNumberGenerator {
    NonEmpty<[Element]>(rawValue: self.rawValue.shuffled(using: &generator))!
  }

  public func shuffled() -> NonEmpty<[Element]> {
    NonEmpty<[Element]>(rawValue: self.rawValue.shuffled())!
  }

  public func map<T>(_ transform: (Element) throws -> T) rethrows -> NonEmpty<[T]> {
    NonEmpty<[T]>(rawValue: try self.rawValue.map(transform))!
  }

  public func flatMap<SegmentOfResult>(
    _ transform: (Element) throws -> NonEmpty<SegmentOfResult>
  ) rethrows -> NonEmpty<[SegmentOfResult.Element]> where SegmentOfResult: Sequence {
    NonEmpty<[SegmentOfResult.Element]>(rawValue: try self.rawValue.flatMap(transform))!
  }
}

extension NonEmpty: CustomStringConvertible {
  public var description: String {
    return String(describing: self.rawValue)
  }
}

extension NonEmpty: Equatable where Collection: Equatable {}

extension NonEmpty: Hashable where Collection: Hashable {}

extension NonEmpty: Sendable where Collection: Sendable {}

extension NonEmpty: Comparable where Collection: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension NonEmpty: Encodable where Collection: Encodable {
  public func encode(to encoder: Encoder) throws {
    do {
      var container = encoder.singleValueContainer()
      try container.encode(self.rawValue)
    } catch {
      try self.rawValue.encode(to: encoder)
    }
  }
}

extension NonEmpty: Decodable where Collection: Decodable {
  public init(from decoder: Decoder) throws {
    let collection: Collection
    do {
      collection = try decoder.singleValueContainer().decode(Collection.self)
    } catch {
      collection = try Collection(from: decoder)
    }

    guard !collection.isEmpty else {
      throw DecodingError.dataCorrupted(
        .init(codingPath: decoder.codingPath, debugDescription: "Non-empty collection expected")
      )
    }
    self.init(rawValue: collection)!
  }
}

extension NonEmpty: RawRepresentable {}

extension NonEmpty where Collection.Element: Comparable {
  public func max() -> Element {
    self.rawValue.max()!
  }

  public func min() -> Element {
    self.rawValue.min()!
  }

  public func sorted() -> NonEmpty<[Element]> {
    return NonEmpty<[Element]>(rawValue: self.rawValue.sorted())!
  }
}

extension NonEmpty: BidirectionalCollection where Collection: BidirectionalCollection {
  public func index(before i: Index) -> Index {
    self.rawValue.index(before: i)
  }

  public var last: Element { self.rawValue.last! }
}

extension NonEmpty: MutableCollection where Collection: MutableCollection {
  public subscript(position: Index) -> Element {
    _read { yield self.rawValue[position] }
    _modify { yield &self.rawValue[position] }
  }
}

extension NonEmpty: RandomAccessCollection where Collection: RandomAccessCollection {}

extension NonEmpty where Collection: MutableCollection & RandomAccessCollection {
  public mutating func shuffle<T: RandomNumberGenerator>(using generator: inout T) {
    self.rawValue.shuffle(using: &generator)
  }
}

public typealias NonEmptyArray<Element> = NonEmpty<[Element]>
