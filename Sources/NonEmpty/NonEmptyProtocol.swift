public protocol NonEmptyProtocol: Swift.Collection, RawRepresentable
where RawValue: Swift.Collection,
      Element == RawValue.Element,
      Index == RawValue.Index,
      Collection.Element == Element,
      Collection.Index == Index
{
  associatedtype Collection: Swift.Collection
  typealias Tail = Slice<Collection>
  var minimumCount: Int { get }
  var tail: Tail { get }
  var wrappedValue: Collection { get set }
  init(from rawValue: Collection) throws
}

extension NonEmptyProtocol {
  public var head: Element { self[self.startIndex] }
}

// MARK: - Swift.Collection

extension NonEmptyProtocol {
  public var startIndex: Index { self.rawValue.startIndex }
  public var endIndex: Index { self.rawValue.endIndex }

  public func index(after i: RawValue.Index) -> RawValue.Index { self.rawValue.index(after: i) }

  public var first: Element { self.head }

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

extension NonEmptyProtocol where Collection.Element: Comparable {
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
