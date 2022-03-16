/// - Note: We need to separate `WithMinimumCount` from `NonEmptyProtocol`
///   to avoid the "Self or associated type requirement".
public protocol WithMinimumCount {
  static var minimumCount: Int { get }
}

public protocol NonEmptyProtocol: Swift.Collection, RawRepresentable, WithMinimumCount
where RawValue: Swift.Collection,
      Element == RawValue.Element,
      Index == RawValue.Index,
      Collection.Element == Element,
      Collection.Index == Index
{
  associatedtype Collection: Swift.Collection
  var tail: Slice<Collection> { get }
  var wrappedValue: Collection { get set }
  init(from wrappedValue: Collection) throws
}

extension NonEmptyProtocol {
  public var head: Element { self[self.startIndex] }
}
