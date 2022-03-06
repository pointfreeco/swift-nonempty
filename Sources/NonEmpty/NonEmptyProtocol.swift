public protocol NonEmptyProtocol: Swift.Collection, RawRepresentable
where RawValue: Swift.Collection,
      Element == RawValue.Element,
      Collection.Element == Element
{
  associatedtype Collection: Swift.Collection
}
extension NonEmpty: NonEmptyProtocol {}
