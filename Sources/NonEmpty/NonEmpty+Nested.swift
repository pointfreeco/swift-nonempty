/// Just a type alias that makes sense with `_AtLeast2`, `_AtLeast3`…
public typealias _AtLeast1 <C: Swift.Collection> = NonEmpty<C>
public typealias _AtLeast2 <C: Swift.Collection> = NonEmpty<NonEmpty<C>>
public typealias _AtLeast3 <C: Swift.Collection> = NonEmpty<_AtLeast2<C>>
public typealias _AtLeast4 <C: Swift.Collection> = NonEmpty<_AtLeast3<C>>
public typealias _AtLeast5 <C: Swift.Collection> = NonEmpty<_AtLeast4<C>>
public typealias _AtLeast6 <C: Swift.Collection> = NonEmpty<_AtLeast5<C>>
public typealias _AtLeast7 <C: Swift.Collection> = NonEmpty<_AtLeast6<C>>
public typealias _AtLeast8 <C: Swift.Collection> = NonEmpty<_AtLeast7<C>>
public typealias _AtLeast9 <C: Swift.Collection> = NonEmpty<_AtLeast8<C>>
public typealias _AtLeast10<C: Swift.Collection> = NonEmpty<_AtLeast9<C>>

extension _AtLeast2 {
  public var second: Collection.Element  { self[self.index(self.startIndex, offsetBy: 1)] }
}
extension _AtLeast3 {
  public var third: Collection.Element   { self[self.index(self.startIndex, offsetBy: 2)] }
}
extension _AtLeast4 {
  public var fourth: Collection.Element  { self[self.index(self.startIndex, offsetBy: 3)] }
}
extension _AtLeast5 {
  public var fifth: Collection.Element   { self[self.index(self.startIndex, offsetBy: 4)] }
}
extension _AtLeast6 {
  public var sixth: Collection.Element   { self[self.index(self.startIndex, offsetBy: 5)] }
}
extension _AtLeast7 {
  public var seventh: Collection.Element { self[self.index(self.startIndex, offsetBy: 6)] }
}
extension _AtLeast8 {
  public var eighth: Collection.Element  { self[self.index(self.startIndex, offsetBy: 7)] }
}
extension _AtLeast9 {
  public var ninth: Collection.Element   { self[self.index(self.startIndex, offsetBy: 8)] }
}
extension _AtLeast10 {
  public var tenth: Collection.Element   { self[self.index(self.startIndex, offsetBy: 9)] }
}

public func AtLeast1<C: Swift.Collection>(_ c: C) throws -> _AtLeast1<C> {
  try NonEmpty(from: c)
}
public func AtLeast2<C: Swift.Collection>(_ c: C) throws -> _AtLeast2<C> {
  try NonEmpty(AtLeast1(c))
}
public func AtLeast3<C: Swift.Collection>(_ c: C) throws -> _AtLeast3<C> {
  try NonEmpty(AtLeast2(c))
}
public func AtLeast4<C: Swift.Collection>(_ c: C) throws -> _AtLeast4<C> {
  try NonEmpty(AtLeast3(c))
}
public func AtLeast5<C: Swift.Collection>(_ c: C) throws -> _AtLeast5<C> {
  try NonEmpty(AtLeast4(c))
}
public func AtLeast6<C: Swift.Collection>(_ c: C) throws -> _AtLeast6<C> {
  try NonEmpty(AtLeast5(c))
}
public func AtLeast7<C: Swift.Collection>(_ c: C) throws -> _AtLeast7<C> {
  try NonEmpty(AtLeast6(c))
}
public func AtLeast8<C: Swift.Collection>(_ c: C) throws -> _AtLeast8<C> {
  try NonEmpty(AtLeast7(c))
}
public func AtLeast9<C: Swift.Collection>(_ c: C) throws -> _AtLeast9<C> {
  try NonEmpty(AtLeast8(c))
}
public func AtLeast10<C: Swift.Collection>(_ c: C) throws -> _AtLeast10<C> {
  try NonEmpty(AtLeast9(c))
}

public func AtLeast1<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> _AtLeast1<NonEmpty<C>> {
  try NonEmpty(nonEmpty)
}
public func AtLeast2<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> _AtLeast2<NonEmpty<C>> {
  try NonEmpty(AtLeast1(nonEmpty))
}
public func AtLeast3<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> _AtLeast3<NonEmpty<C>> {
  try NonEmpty(AtLeast2(nonEmpty))
}
public func AtLeast4<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> _AtLeast4<NonEmpty<C>> {
  try NonEmpty(AtLeast3(nonEmpty))
}
public func AtLeast5<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> _AtLeast5<NonEmpty<C>> {
  try NonEmpty(AtLeast4(nonEmpty))
}
public func AtLeast6<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> _AtLeast6<NonEmpty<C>> {
  try NonEmpty(AtLeast5(nonEmpty))
}
public func AtLeast7<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> _AtLeast7<NonEmpty<C>> {
  try NonEmpty(AtLeast6(nonEmpty))
}
public func AtLeast8<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> _AtLeast8<NonEmpty<C>> {
  try NonEmpty(AtLeast7(nonEmpty))
}
public func AtLeast9<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> _AtLeast9<NonEmpty<C>> {
  try NonEmpty(AtLeast8(nonEmpty))
}
public func AtLeast10<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> _AtLeast10<NonEmpty<C>> {
  try NonEmpty(AtLeast9(nonEmpty))
}

fileprivate typealias _AtLeast11<C: Swift.Collection> = NonEmpty<_AtLeast10<C>>
extension _AtLeast11 {
  public var drop10: NonEmpty<Collection.SubSequence> {
    try! NonEmpty<Collection.SubSequence>(from: self.rawValue.dropFirst(10))
  }
}
