@dynamicMemberLookup
public struct NonEmpty<Collection: Swift.Collection> {
  public internal(set) var tail: Slice<Collection>

  public static var minimumCount: Int {
    if let T = Collection.self as? WithMinimumCount.Type {
      return T.minimumCount + 1
    } else {
      return 1
    }
  }

  public init(fromSlice slice: Slice<Collection>) throws {
    guard !slice.dropFirst(Self.minimumCount - 1).isEmpty else {
      if Self.minimumCount == 1 {
        throw NonEmptyError.emptyCollection
      } else {
        throw NonEmptyError.tooFewElements(expected: Self.minimumCount)
      }
    }
    let bounds = (slice.index(after: slice.startIndex))..<slice.endIndex
    self.tail = Slice(base: slice.base, bounds: bounds)
  }

  public init(from wrappedValue: Collection) throws {
    let slice = Slice(base: wrappedValue, bounds: wrappedValue.startIndex..<wrappedValue.endIndex)
    try self.init(fromSlice: slice)
  }

  public subscript<Subject>(dynamicMember keyPath: KeyPath<Collection, Subject>) -> Subject {
    self.rawValue[keyPath: keyPath]
  }
}

extension NonEmpty: NonEmptyProtocol {
  public var wrappedValue: Collection {
    get { self.rawValue }
    set { self.rawValue = newValue }
  }
}

extension NonEmpty: RawRepresentable {
  public internal(set) var rawValue: Collection {
    get { tail.base }
    set {
      self = try! Self.init(from: newValue)
    }
  }
  public init?(rawValue: Collection) {
    try? self.init(from: rawValue)
  }
}

extension NonEmpty: Swift.Collection {
  public typealias Element = RawValue.Element
  public typealias Index = RawValue.Index

  public var startIndex: Index { self.rawValue.startIndex }

  public var endIndex: Index { self.rawValue.endIndex }

  public subscript(position: Index) -> Element { self.rawValue[position] }

  public func index(after i: Index) -> Index {
    self.rawValue.index(after: i)
  }

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
    String(describing: self.rawValue)
  }
}

extension NonEmpty: Equatable where Collection: Equatable {}

extension NonEmpty: Hashable where Collection: Hashable {}

extension NonEmpty: Comparable where Collection: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension NonEmpty: Encodable where Collection: Encodable {
  public func encode(to encoder: Encoder) throws {
    try self.rawValue.encode(to: encoder)
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

extension NonEmpty: BidirectionalCollection where RawValue: BidirectionalCollection {}
extension NonEmptyProtocol where RawValue: BidirectionalCollection {
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
