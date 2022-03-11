@dynamicMemberLookup
public struct NonEmpty<Collection: Swift.Collection>: Swift.Collection, NonEmptyProtocol {
  public typealias Element = Collection.Element
  public typealias Index = Collection.Index

  public internal(set) var tail: Slice<Collection>

  public let minimumCount: Int = 1

  public var wrappedValue: Collection {
    get { rawValue }
    set { rawValue = newValue }
  }

  public init(fromSlice slice: Slice<Collection>) throws {
    guard !slice.isEmpty else {
      throw NonEmptyError.emptyCollection
    }
    let bounds = (slice.index(after: slice.startIndex))..<slice.endIndex
    self.tail = Slice(base: slice.base, bounds: bounds)
  }

  public init(from rawValue: Collection) throws {
    try self.init(fromSlice: Slice(base: rawValue, bounds: rawValue.startIndex..<rawValue.endIndex))
  }

  public init?(rawValue: Collection) {
    try? self.init(from: rawValue)
  }

  public subscript<Subject>(dynamicMember keyPath: KeyPath<Collection, Subject>) -> Subject {
    self.rawValue[keyPath: keyPath]
  }

  public subscript(position: Index) -> Element { self.rawValue[position] }
}

extension NonEmpty: CustomStringConvertible {
  public var description: String {
    return String(describing: self.rawValue)
  }
}

extension NonEmpty: Equatable where Collection: Equatable {
  public static func == (lhs: NonEmpty<Collection>, rhs: NonEmpty<Collection>) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

extension NonEmpty: Hashable where Collection: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.rawValue)
  }
}

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

extension NonEmpty: RawRepresentable {
  public internal(set) var rawValue: Collection {
    get { self.tail.base }
    set {
      self.tail = Slice(base: newValue, bounds: (newValue.index(after: newValue.startIndex))..<newValue.endIndex)
    }
  }
}

extension NonEmpty: BidirectionalCollection where Collection: BidirectionalCollection {
  public func index(before i: Index) -> Index {
    self.rawValue.index(before: i)
  }

  public var last: Element { self.tail.isEmpty ? self.head : self.tail.last! }
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
