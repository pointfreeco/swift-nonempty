public typealias AtLeast1 <C: Swift.Collection> = NonEmpty<C>
public typealias AtLeast2 <C: Swift.Collection> = NonEmpty<AtLeast1<C>>
public typealias AtLeast3 <C: Swift.Collection> = NonEmpty<AtLeast2<C>>
public typealias AtLeast4 <C: Swift.Collection> = NonEmpty<AtLeast3<C>>
public typealias AtLeast5 <C: Swift.Collection> = NonEmpty<AtLeast4<C>>
public typealias AtLeast6 <C: Swift.Collection> = NonEmpty<AtLeast5<C>>
public typealias AtLeast7 <C: Swift.Collection> = NonEmpty<AtLeast6<C>>
public typealias AtLeast8 <C: Swift.Collection> = NonEmpty<AtLeast7<C>>
public typealias AtLeast9 <C: Swift.Collection> = NonEmpty<AtLeast8<C>>
public typealias AtLeast10<C: Swift.Collection> = NonEmpty<AtLeast9<C>>

extension NonEmptyProtocol {
  @_disfavoredOverload
  public init(_ c: Collection) throws {
    try self.init(from: c)
  }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol
{
  public var second: Element { self[self.index(self.startIndex, offsetBy: 1)] }
  public init(_ c: Collection.Collection) throws {
    try self.init(.init(c))
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    tail: Collection.Collection
  ) where Collection.Collection: RangeReplaceableCollection {
    var rawValue = tail
    rawValue.insert(contentsOf: [e1, e2], at: rawValue.startIndex)
    try! self.init(rawValue)
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ tail: Element...
  ) where Collection.Collection: RangeReplaceableCollection {
    self.init(e1, e2, tail: .init(tail))
  }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol,
      Collection.Collection: NonEmptyProtocol
{
  public var third: Element { self[self.index(self.startIndex, offsetBy: 2)] }
  public init(_ c: Collection.Collection.Collection) throws {
    try self.init(.init(.init(c)))
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    tail: Collection.Collection.Collection
  ) where Collection.Collection.Collection: RangeReplaceableCollection {
    var rawValue = tail
    rawValue.insert(contentsOf: [e1, e2, e3], at: rawValue.startIndex)
    try! self.init(rawValue)
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    _ tail: Element...
  ) where Collection.Collection.Collection: RangeReplaceableCollection {
    self.init(e1, e2, e3, tail: .init(tail))
  }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol,
      Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection: NonEmptyProtocol
{
  public var fourth: Element { self[self.index(self.startIndex, offsetBy: 3)] }
  public init(_ c: Collection.Collection.Collection.Collection) throws {
    try self.init(.init(.init(.init(c))))
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    _ e4: Element,
    tail: Collection.Collection.Collection.Collection
  ) where Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    var rawValue = tail
    rawValue.insert(contentsOf: [e1, e2, e3, e4], at: rawValue.startIndex)
    try! self.init(rawValue)
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    _ e4: Element,
    _ tail: Element...
  ) where Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    self.init(e1, e2, e3, e4, tail: .init(tail))
  }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol,
      Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection: NonEmptyProtocol
{
  public var fifth: Element { self[self.index(self.startIndex, offsetBy: 4)] }
  public init(_ c: Collection.Collection.Collection.Collection.Collection) throws {
    try self.init(.init(.init(.init(.init(c)))))
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    _ e4: Element,
    _ e5: Element,
    tail: Collection.Collection.Collection.Collection.Collection
  ) where Collection.Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    var rawValue = tail
    rawValue.insert(contentsOf: [e1, e2, e3, e4, e5], at: rawValue.startIndex)
    try! self.init(rawValue)
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    _ e4: Element,
    _ e5: Element,
    _ tail: Element...
  ) where Collection.Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    self.init(e1, e2, e3, e4, e5, tail: .init(tail))
  }
}
extension NonEmptyProtocol
where Collection: NonEmptyProtocol,
      Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection: NonEmptyProtocol,
      Collection.Collection.Collection.Collection.Collection: NonEmptyProtocol
{
  public var sixth: Element { self[self.index(self.startIndex, offsetBy: 5)] }
  public init(_ c: Collection.Collection.Collection.Collection.Collection.Collection) throws {
    try self.init(.init(.init(.init(.init(.init(c))))))
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    _ e4: Element,
    _ e5: Element,
    _ e6: Element,
    tail: Collection.Collection.Collection.Collection.Collection.Collection
  ) where Collection.Collection.Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    var rawValue = tail
    rawValue.insert(contentsOf: [e1, e2, e3, e4, e5, e6], at: rawValue.startIndex)
    try! self.init(rawValue)
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    _ e4: Element,
    _ e5: Element,
    _ e6: Element,
    _ tail: Element...
  ) where Collection.Collection.Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    self.init(e1, e2, e3, e4, e5, e6, tail: .init(tail))
  }
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
  public init(_ c: Collection.Collection.Collection.Collection.Collection.Collection.Collection) throws {
    try self.init(.init(.init(.init(.init(.init(.init(c)))))))
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    _ e4: Element,
    _ e5: Element,
    _ e6: Element,
    _ e7: Element,
    tail: Collection.Collection.Collection.Collection.Collection.Collection.Collection
  ) where Collection.Collection.Collection.Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    var rawValue = tail
    rawValue.insert(contentsOf: [e1, e2, e3, e4, e5, e6, e7], at: rawValue.startIndex)
    try! self.init(rawValue)
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    _ e4: Element,
    _ e5: Element,
    _ e6: Element,
    _ e7: Element,
    _ tail: Element...
  ) where Collection.Collection.Collection.Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    self.init(e1, e2, e3, e4, e5, e6, e7, tail: .init(tail))
  }
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
  public var eighth: Element { self[self.index(self.startIndex, offsetBy: 7)] }
  public init(_ c: Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection) throws {
    try self.init(.init(.init(.init(.init(.init(.init(.init(c))))))))
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    _ e4: Element,
    _ e5: Element,
    _ e6: Element,
    _ e7: Element,
    _ e8: Element,
    tail: Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection
  ) where Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    var rawValue = tail
    rawValue.insert(contentsOf: [e1, e2, e3, e4, e5, e6, e7, e8], at: rawValue.startIndex)
    try! self.init(rawValue)
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    _ e4: Element,
    _ e5: Element,
    _ e6: Element,
    _ e7: Element,
    _ e8: Element,
    _ tail: Element...
  ) where Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    self.init(e1, e2, e3, e4, e5, e6, e7, e8, tail: .init(tail))
  }
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
  public var ninth: Element { self[self.index(self.startIndex, offsetBy: 8)] }
  public init(_ c: Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection) throws {
    try self.init(.init(.init(.init(.init(.init(.init(.init(.init(c)))))))))
  }
  public init(
    _ e1: Element,
    _ e2: Element,
    _ e3: Element,
    _ e4: Element,
    _ e5: Element,
    _ e6: Element,
    _ e7: Element,
    _ e8: Element,
    _ e9: Element,
    tail: Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection
  ) where Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    var rawValue = tail
    rawValue.insert(contentsOf: [e1, e2, e3, e4, e5, e6, e7, e8, e9], at: rawValue.startIndex)
    try! self.init(rawValue)
  }
  public init(
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
  ) where Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    self.init(e1, e2, e3, e4, e5, e6, e7, e8, e9, tail: .init(tail))
  }
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
  public var tenth: Element { self[self.index(self.startIndex, offsetBy: 9)] }
  public init(_ c: Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection) throws {
    try self.init(.init(.init(.init(.init(.init(.init(.init(.init(.init(c))))))))))
  }
  public init(
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
    tail: Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection
  ) where Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    var rawValue = tail
    rawValue.insert(contentsOf: [e1, e2, e3, e4, e5, e6, e7, e8, e9, e10], at: rawValue.startIndex)
    try! self.init(rawValue)
  }
  public init(
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
  ) where Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection.Collection: RangeReplaceableCollection {
    self.init(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, tail: .init(tail))
  }
}
