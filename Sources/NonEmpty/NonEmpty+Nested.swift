// MARK: - Base struct

public struct OneMore<Collection: NonEmptyProtocol>: NonEmptyProtocol {
  public let minimumCount: Int
  
  public var wrappedValue: Collection {
    get { self.tail.base }
    set {
      self.tail = Slice(base: newValue, bounds: (newValue.index(after: newValue.startIndex))..<newValue.endIndex)
    }
  }
  
  public var head: Element { self[self.startIndex] }
  public var tail: Slice<Collection>
  
  public init(fromSlice slice: Slice<Collection>) throws {
    self.minimumCount = slice.base.minimumCount + 1
    guard !slice.base.tail.isEmpty else {
      throw NonEmptyError.tooFewElements(expected: self.minimumCount)
    }
    let bounds = (slice.index(after: slice.startIndex))..<slice.endIndex
    self.tail = Slice(base: slice.base, bounds: bounds)
  }
  
  public init(from wrappedValue: Collection) throws {
    try self.init(fromSlice: Slice(base: wrappedValue, bounds: wrappedValue.tail.startIndex..<wrappedValue.endIndex))
  }
}

extension OneMore: Swift.Collection {
  public typealias Element = Collection.Element
  public typealias Index = Collection.Index

  public subscript(position: Index) -> Element { self.rawValue[position] }
}

extension OneMore {
  public typealias RawValue = Collection.RawValue

  public var rawValue: RawValue { self.wrappedValue.rawValue }

  public init?(rawValue: RawValue) {
    guard let collection = Collection(rawValue: rawValue) else { return nil }
    try? self.init(from: collection)
  }
}

extension OneMore: CustomStringConvertible {
  public var description: String {
    return String(describing: self.rawValue)
  }
}

extension OneMore: Equatable where Collection: Equatable {
  public static func == (lhs: OneMore<Collection>, rhs: OneMore<Collection>) -> Bool {
    lhs.wrappedValue == rhs.wrappedValue
  }
}

extension OneMore: Hashable where Collection: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.wrappedValue)
  }
}

extension OneMore: Comparable where Collection: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.wrappedValue < rhs.wrappedValue
  }
}

extension OneMore: Encodable where Collection: Encodable {
  public func encode(to encoder: Encoder) throws {
    try self.wrappedValue.encode(to: encoder)
  }
}

extension OneMore: Decodable where Collection: Decodable {
  public init(from decoder: Decoder) throws {
    let collection = try Collection(from: decoder)
    do {
      try self.init(from: collection)
    } catch {
      throw DecodingError.dataCorrupted(
        .init(codingPath: decoder.codingPath, debugDescription: String(reflecting: error))
      )
    }
  }
}

extension OneMore: BidirectionalCollection where Collection: BidirectionalCollection {
  public func index(before i: Index) -> Index {
    self.wrappedValue.index(before: i)
  }

  public var last: Element { self.tail.isEmpty ? self.head : self.tail.last! }
}

extension OneMore: MutableCollection where Collection: MutableCollection {
  public subscript(position: Index) -> Element {
    _read { yield self.wrappedValue[position] }
    _modify { yield &self.wrappedValue[position] }
  }
}

extension OneMore: RandomAccessCollection where Collection: RandomAccessCollection {}

extension OneMore where Collection: MutableCollection & RandomAccessCollection {
  public mutating func shuffle<T: RandomNumberGenerator>(using generator: inout T) {
    self.wrappedValue.shuffle(using: &generator)
  }
}

// NB: `OneMore` does not conditionally conform to `RangeReplaceableCollection` because it contains destructive methods.
extension OneMore where Collection.RawValue: RangeReplaceableCollection {
  public init(_ head: Element, tail: Collection)
  where Collection.RawValue: RangeReplaceableCollection
  {
    var rawValue = tail.rawValue
    rawValue.insert(head, at: rawValue.startIndex)
    let tail = Collection(rawValue: rawValue)!
    self.tail = Slice(base: tail, bounds: tail.startIndex..<tail.endIndex)
    self.minimumCount = tail.minimumCount + 1
  }

  public init(_ head: Element, _ tail: Element...) {
    self.init(head, tail: Collection(rawValue: Collection.RawValue(tail))!)
  }
}

// MARK: - Accessors

extension NonEmptyProtocol
where Collection: NonEmptyProtocol
{
  public var second: Element  { self[self.index(self.startIndex, offsetBy: 1)] }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol,
      Collection.Collection: NonEmptyProtocol
{
  public var third: Element   { self[self.index(self.startIndex, offsetBy: 2)] }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol,
      Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection: NonEmptyProtocol
{
  public var fourth: Element  { self[self.index(self.startIndex, offsetBy: 3)] }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol,
      Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection: NonEmptyProtocol
{
  public var fifth: Element   { self[self.index(self.startIndex, offsetBy: 4)] }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol,
      Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol
{
  public var sixth: Element   { self[self.index(self.startIndex, offsetBy: 5)] }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol,
      Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol
{
  public var seventh: Element { self[self.index(self.startIndex, offsetBy: 6)] }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol,
      Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol
{
  public var eighth: Element  { self[self.index(self.startIndex, offsetBy: 7)] }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol,
      Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol
{
  public var ninth: Element   { self[self.index(self.startIndex, offsetBy: 8)] }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol,
      Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol
{
  public var tenth: Element   { self[self.index(self.startIndex, offsetBy: 9)] }
}

// MARK: - Constructors

public func atLeast1<C: Swift.Collection>(_ c: C) throws -> NonEmpty<C> {
  try NonEmpty(from: c)
}
public func atLeast2<C: Swift.Collection>(_ c: C) throws -> OneMore<NonEmpty<C>> {
  try OneMore(from: atLeast1(c))
}
public func atLeast3<C: Swift.Collection>(_ c: C) throws -> OneMore<OneMore<NonEmpty<C>>> {
  try OneMore(from: atLeast2(c))
}
public func atLeast4<C: Swift.Collection>(_ c: C) throws -> OneMore<OneMore<OneMore<NonEmpty<C>>>> {
  try OneMore(from: atLeast3(c))
}
public func atLeast5<C: Swift.Collection>(_ c: C) throws -> OneMore<OneMore<OneMore<OneMore<NonEmpty<C>>>>> {
  try OneMore(from: atLeast4(c))
}
public func atLeast6<C: Swift.Collection>(_ c: C) throws -> OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<C>>>>>> {
  try OneMore(from: atLeast5(c))
}
public func atLeast7<C: Swift.Collection>(_ c: C) throws -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<C>>>>>>> {
  try OneMore(from: atLeast6(c))
}
public func atLeast8<C: Swift.Collection>(_ c: C) throws -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<C>>>>>>>> {
  try OneMore(from: atLeast7(c))
}
public func atLeast9<C: Swift.Collection>(_ c: C) throws -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<C>>>>>>>>> {
  try OneMore(from: atLeast8(c))
}
public func atLeast10<C: Swift.Collection>(_ c: C) throws -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<C>>>>>>>>>> {
  try OneMore(from: atLeast9(c))
}

// MARK: Safe constructors

public func atLeast1<C: RangeReplaceableCollection>(
  _ e1: C.Element,
  tail: C
) -> NonEmpty<C> {
  return NonEmpty(e1, tail: tail)
}
public func atLeast1<Element>(
  _ e1: Element,
  _ tail: Element...
) -> NonEmpty<[Element]> {
  return atLeast1(e1, tail: tail)
}
public func atLeast2<C: RangeReplaceableCollection>(
  _ e1: C.Element,
  _ e2: C.Element,
  tail: C
) -> OneMore<NonEmpty<C>> {
  return OneMore(e1, tail: NonEmpty(e2, tail: tail))
}
public func atLeast2<Element>(
  _ e1: Element,
  _ e2: Element,
  _ tail: Element...
) -> OneMore<NonEmpty<[Element]>> {
  return atLeast2(e1, e2, tail: tail)
}
public func atLeast3<C: RangeReplaceableCollection>(
  _ e1: C.Element,
  _ e2: C.Element,
  _ e3: C.Element,
  tail: C
) -> OneMore<OneMore<NonEmpty<C>>> {
  return OneMore(e1, tail: atLeast2(e2, e3, tail: tail))
}
public func atLeast3<Element>(
  _ e1: Element,
  _ e2: Element,
  _ e3: Element,
  _ tail: Element...
) -> OneMore<OneMore<NonEmpty<[Element]>>> {
  return atLeast3(e1, e2, e3, tail: tail)
}
public func atLeast4<C: RangeReplaceableCollection>(
  _ e1: C.Element,
  _ e2: C.Element,
  _ e3: C.Element,
  _ e4: C.Element,
  tail: C
) -> OneMore<OneMore<OneMore<NonEmpty<C>>>> {
  return OneMore(e1, tail: atLeast3(e2, e3, e4, tail: tail))
}
public func atLeast4<Element>(
  _ e1: Element,
  _ e2: Element,
  _ e3: Element,
  _ e4: Element,
  _ tail: Element...
) -> OneMore<OneMore<OneMore<NonEmpty<[Element]>>>> {
  return atLeast4(e1, e2, e3, e4, tail: tail)
}
public func atLeast5<C: RangeReplaceableCollection>(
  _ e1: C.Element,
  _ e2: C.Element,
  _ e3: C.Element,
  _ e4: C.Element,
  _ e5: C.Element,
  tail: C
) -> OneMore<OneMore<OneMore<OneMore<NonEmpty<C>>>>> {
  return OneMore(e1, tail: atLeast4(e2, e3, e4, e5, tail: tail))
}
public func atLeast5<Element>(
  _ e1: Element,
  _ e2: Element,
  _ e3: Element,
  _ e4: Element,
  _ e5: Element,
  _ tail: Element...
) -> OneMore<OneMore<OneMore<OneMore<NonEmpty<[Element]>>>>> {
  return atLeast5(e1, e2, e3, e4, e5, tail: tail)
}
public func atLeast6<C: RangeReplaceableCollection>(
  _ e1: C.Element,
  _ e2: C.Element,
  _ e3: C.Element,
  _ e4: C.Element,
  _ e5: C.Element,
  _ e6: C.Element,
  tail: C
) -> OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<C>>>>>> {
  return OneMore(e1, tail: atLeast5(e2, e3, e4, e5, e6, tail: tail))
}
public func atLeast6<Element>(
  _ e1: Element,
  _ e2: Element,
  _ e3: Element,
  _ e4: Element,
  _ e5: Element,
  _ e6: Element,
  _ tail: Element...
) -> OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<[Element]>>>>>> {
  return atLeast6(e1, e2, e3, e4, e5, e6, tail: tail)
}
public func atLeast7<C: RangeReplaceableCollection>(
  _ e1: C.Element,
  _ e2: C.Element,
  _ e3: C.Element,
  _ e4: C.Element,
  _ e5: C.Element,
  _ e6: C.Element,
  _ e7: C.Element,
  tail: C
) -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<C>>>>>>> {
  return OneMore(e1, tail: atLeast6(e2, e3, e4, e5, e6, e7, tail: tail))
}
public func atLeast7<Element>(
  _ e1: Element,
  _ e2: Element,
  _ e3: Element,
  _ e4: Element,
  _ e5: Element,
  _ e6: Element,
  _ e7: Element,
  _ tail: Element...
) -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<[Element]>>>>>>> {
  return atLeast7(e1, e2, e3, e4, e5, e6, e7, tail: tail)
}
public func atLeast8<C: RangeReplaceableCollection>(
  _ e1: C.Element,
  _ e2: C.Element,
  _ e3: C.Element,
  _ e4: C.Element,
  _ e5: C.Element,
  _ e6: C.Element,
  _ e7: C.Element,
  _ e8: C.Element,
  tail: C
) -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<C>>>>>>>> {
  return OneMore(e1, tail: atLeast7(e2, e3, e4, e5, e6, e7, e8, tail: tail))
}
public func atLeast8<Element>(
  _ e1: Element,
  _ e2: Element,
  _ e3: Element,
  _ e4: Element,
  _ e5: Element,
  _ e6: Element,
  _ e7: Element,
  _ e8: Element,
  _ tail: Element...
) -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<[Element]>>>>>>>> {
  return atLeast8(e1, e2, e3, e4, e5, e6, e7, e8, tail: tail)
}
public func atLeast9<C: RangeReplaceableCollection>(
  _ e1: C.Element,
  _ e2: C.Element,
  _ e3: C.Element,
  _ e4: C.Element,
  _ e5: C.Element,
  _ e6: C.Element,
  _ e7: C.Element,
  _ e8: C.Element,
  _ e9: C.Element,
  tail: C
) -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<C>>>>>>>>> {
  return OneMore(e1, tail: atLeast8(e2, e3, e4, e5, e6, e7, e8, e9, tail: tail))
}
public func atLeast9<Element>(
  _ e1: Element,
  _ e2: Element,
  _ e3: Element,
  _ e4: Element,
  _ e5: Element,
  _ e6: Element,
  _ e7: Element,
  _ e8: Element,
  _ e9: Element,
  _ tail: Element...
) -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<[Element]>>>>>>>>> {
  return atLeast9(e1, e2, e3, e4, e5, e6, e7, e8, e9, tail: tail)
}
public func atLeast10<C: RangeReplaceableCollection>(
  _ e1: C.Element,
  _ e2: C.Element,
  _ e3: C.Element,
  _ e4: C.Element,
  _ e5: C.Element,
  _ e6: C.Element,
  _ e7: C.Element,
  _ e8: C.Element,
  _ e9: C.Element,
  _ e10: C.Element,
  tail: C
) -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<C>>>>>>>>>> {
  return OneMore(e1, tail: atLeast9(e2, e3, e4, e5, e6, e7, e8, e9, e10, tail: tail))
}
public func atLeast10<Element>(
  _ e1: Element,
  _ e2: Element,
  _ e3: Element,
  _ e4: Element,
  _ e5: Element,
  _ e6: Element,
  _ e7: Element,
  _ e8: Element,
  _ e9: Element,
  _ e10: Element,
  _ tail: Element...
) -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<NonEmpty<[Element]>>>>>>>>>> {
  return atLeast10(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, tail: tail)
}

// MARK: - Over 10

public func atLeast1More<N: NonEmptyProtocol>(_ nonEmpty: OneMore<N>) throws -> OneMore<OneMore<N>> {
  try OneMore(from: nonEmpty)
}
public func atLeast2More<N: NonEmptyProtocol>(_ nonEmpty: OneMore<N>) throws -> OneMore<OneMore<OneMore<N>>> {
  try OneMore(from: atLeast1More(nonEmpty))
}
public func atLeast3More<N: NonEmptyProtocol>(_ nonEmpty: OneMore<N>) throws -> OneMore<OneMore<OneMore<OneMore<N>>>> {
  try OneMore(from: atLeast2More(nonEmpty))
}
public func atLeast4More<N: NonEmptyProtocol>(_ nonEmpty: OneMore<N>) throws -> OneMore<OneMore<OneMore<OneMore<OneMore<N>>>>> {
  try OneMore(from: atLeast3More(nonEmpty))
}
public func atLeast5More<N: NonEmptyProtocol>(_ nonEmpty: OneMore<N>) throws -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<N>>>>>> {
  try OneMore(from: atLeast4More(nonEmpty))
}
public func atLeast6More<N: NonEmptyProtocol>(_ nonEmpty: OneMore<N>) throws -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<N>>>>>>> {
  try OneMore(from: atLeast5More(nonEmpty))
}
public func atLeast7More<N: NonEmptyProtocol>(_ nonEmpty: OneMore<N>) throws -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<N>>>>>>>> {
  try OneMore(from: atLeast6More(nonEmpty))
}
public func atLeast8More<N: NonEmptyProtocol>(_ nonEmpty: OneMore<N>) throws -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<N>>>>>>>>> {
  try OneMore(from: atLeast7More(nonEmpty))
}
public func atLeast9More<N: NonEmptyProtocol>(_ nonEmpty: OneMore<N>) throws -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<N>>>>>>>>>> {
  try OneMore(from: atLeast8More(nonEmpty))
}
public func atLeast10More<N: NonEmptyProtocol>(_ nonEmpty: OneMore<N>) throws -> OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<OneMore<N>>>>>>>>>>> {
  try OneMore(from: atLeast9More(nonEmpty))
}
