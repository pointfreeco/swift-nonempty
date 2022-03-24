/// - Note: We need to separate `WithMinimumCount` from `NonEmptyProtocol`
///   to avoid the "Self or associated type requirement".
public protocol WithMinimumCount {
  static var minimumCount: Int { get }
}

public protocol NonEmptyProtocol: Swift.Collection, RawRepresentable, WithMinimumCount
where Element == RawValue.Element,
      Index == RawValue.Index,
      Collection == RawValue
{
  associatedtype Collection: Swift.Collection
  init(from rawValue: Collection) throws
}

extension NonEmptyProtocol {
  public var first: Element { self[self.startIndex] }
}
