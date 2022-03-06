/// Just a type alias that makes sense with `AtLeast2`, `AtLeast3`…
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

public func atLeast1<C: Swift.Collection>(_ c: C) throws -> AtLeast1<C> {
  try NonEmpty(from: c)
}
public func atLeast2<C: Swift.Collection>(_ c: C) throws -> AtLeast2<C> {
  try NonEmpty(atLeast1(c))
}
public func atLeast3<C: Swift.Collection>(_ c: C) throws -> AtLeast3<C> {
  try NonEmpty(atLeast2(c))
}
public func atLeast4<C: Swift.Collection>(_ c: C) throws -> AtLeast4<C> {
  try NonEmpty(atLeast3(c))
}
public func atLeast5<C: Swift.Collection>(_ c: C) throws -> AtLeast5<C> {
  try NonEmpty(atLeast4(c))
}
public func atLeast6<C: Swift.Collection>(_ c: C) throws -> AtLeast6<C> {
  try NonEmpty(atLeast5(c))
}
public func atLeast7<C: Swift.Collection>(_ c: C) throws -> AtLeast7<C> {
  try NonEmpty(atLeast6(c))
}
public func atLeast8<C: Swift.Collection>(_ c: C) throws -> AtLeast8<C> {
  try NonEmpty(atLeast7(c))
}
public func atLeast9<C: Swift.Collection>(_ c: C) throws -> AtLeast9<C> {
  try NonEmpty(atLeast8(c))
}
public func atLeast10<C: Swift.Collection>(_ c: C) throws -> AtLeast10<C> {
  try NonEmpty(atLeast9(c))
}

public func atLeast1<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> AtLeast1<NonEmpty<C>> {
  try NonEmpty(nonEmpty)
}
public func atLeast2<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> AtLeast2<NonEmpty<C>> {
  try NonEmpty(atLeast1(nonEmpty))
}
public func atLeast3<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> AtLeast3<NonEmpty<C>> {
  try NonEmpty(atLeast2(nonEmpty))
}
public func atLeast4<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> AtLeast4<NonEmpty<C>> {
  try NonEmpty(atLeast3(nonEmpty))
}
public func atLeast5<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> AtLeast5<NonEmpty<C>> {
  try NonEmpty(atLeast4(nonEmpty))
}
public func atLeast6<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> AtLeast6<NonEmpty<C>> {
  try NonEmpty(atLeast5(nonEmpty))
}
public func atLeast7<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> AtLeast7<NonEmpty<C>> {
  try NonEmpty(atLeast6(nonEmpty))
}
public func atLeast8<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> AtLeast8<NonEmpty<C>> {
  try NonEmpty(atLeast7(nonEmpty))
}
public func atLeast9<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> AtLeast9<NonEmpty<C>> {
  try NonEmpty(atLeast8(nonEmpty))
}
public func atLeast10<C: Swift.Collection>(_ nonEmpty: NonEmpty<C>) throws -> AtLeast10<NonEmpty<C>> {
  try NonEmpty(atLeast9(nonEmpty))
}
