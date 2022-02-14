public typealias NonEmptySet<Element> = NonEmpty<Set<Element>> where Element: Hashable

// NB: `NonEmpty` does not conditionally conform to `SetAlgebra` because it contains destructive methods.
extension NonEmpty where Collection: SetAlgebra, Collection.Element: Hashable {
  public init(_ head: Collection.Element, _ tail: Collection.Element...) {
    var tail = Collection(tail)
    tail.insert(head)
    self.init(rawValue: tail)!
  }

  public init<S>(from elements: S) throws where S: Sequence, Collection.Element == S.Element {
    try self.init(from: Collection(elements))
  }

  public init?<S>(_ elements: S) where S: Sequence, Collection.Element == S.Element {
    self.init(rawValue: Collection(elements))
  }

  public func contains(_ member: Collection.Element) -> Bool {
    self.rawValue.contains(member)
  }

  public func union(_ other: NonEmpty) -> NonEmpty {
    var copy = self
    copy.formUnion(other)
    return copy
  }

  public func union(_ other: Collection) -> NonEmpty {
    var copy = self
    copy.formUnion(other)
    return copy
  }

  public func intersection(_ other: NonEmpty) -> Collection {
    self.rawValue.intersection(other.rawValue)
  }

  public func intersection(_ other: Collection) -> Collection {
    self.rawValue.intersection(other)
  }

  public func symmetricDifference(_ other: NonEmpty) -> Collection {
    self.rawValue.symmetricDifference(other.rawValue)
  }

  public func symmetricDifference(_ other: Collection) -> Collection {
    self.rawValue.symmetricDifference(other)
  }

  @discardableResult
  public mutating func insert(_ newMember: Collection.Element) -> (
    inserted: Bool, memberAfterInsert: Collection.Element
  ) {
    self.rawValue.insert(newMember)
  }

  @discardableResult
  public mutating func update(with newMember: Collection.Element) -> Collection.Element? {
    self.rawValue.update(with: newMember)
  }

  public mutating func formUnion(_ other: NonEmpty) {
    self.rawValue.formUnion(other.rawValue)
  }

  public mutating func formUnion(_ other: Collection) {
    self.rawValue.formUnion(other)
  }

  public func subtracting(_ other: NonEmpty) -> Collection {
    self.rawValue.subtracting(other.rawValue)
  }

  public func subtracting(_ other: Collection) -> Collection {
    self.rawValue.subtracting(other)
  }

  public func isDisjoint(with other: NonEmpty) -> Bool {
    self.rawValue.isDisjoint(with: other.rawValue)
  }

  public func isDisjoint(with other: Collection) -> Bool {
    self.rawValue.isDisjoint(with: other)
  }

  public func isSubset(of other: NonEmpty) -> Bool {
    self.rawValue.isSubset(of: other.rawValue)
  }

  public func isSubset(of other: Collection) -> Bool {
    self.rawValue.isSubset(of: other)
  }

  public func isSuperset(of other: NonEmpty) -> Bool {
    self.rawValue.isSuperset(of: other.rawValue)
  }

  public func isSuperset(of other: Collection) -> Bool {
    self.rawValue.isSuperset(of: other)
  }

  public func isStrictSubset(of other: NonEmpty) -> Bool {
    self.rawValue.isStrictSubset(of: other.rawValue)
  }

  public func isStrictSubset(of other: Collection) -> Bool {
    self.rawValue.isStrictSubset(of: other)
  }

  public func isStrictSuperset(of other: NonEmpty) -> Bool {
    self.rawValue.isStrictSuperset(of: other.rawValue)
  }

  public func isStrictSuperset(of other: Collection) -> Bool {
    self.rawValue.isStrictSuperset(of: other)
  }
}

extension SetAlgebra where Self: Collection, Element: Hashable {
  public func union(_ other: NonEmpty<Self>) -> NonEmpty<Self> {
    var copy = other
    copy.formUnion(self)
    return copy
  }

  public func intersection(_ other: NonEmpty<Self>) -> Self {
    self.intersection(other.rawValue)
  }

  public func symmetricDifference(_ other: NonEmpty<Self>) -> Self {
    self.symmetricDifference(other.rawValue)
  }

  public mutating func formUnion(_ other: NonEmpty<Self>) {
    self.formUnion(other.rawValue)
  }

  public func subtracting(_ other: NonEmpty<Self>) -> Self {
    self.subtracting(other.rawValue)
  }

  public func isDisjoint(with other: NonEmpty<Self>) -> Bool {
    self.isDisjoint(with: other.rawValue)
  }

  public func isSubset(of other: NonEmpty<Self>) -> Bool {
    self.isSubset(of: other.rawValue)
  }

  public func isSuperset(of other: NonEmpty<Self>) -> Bool {
    self.isSuperset(of: other.rawValue)
  }

  public func isStrictSubset(of other: NonEmpty<Self>) -> Bool {
    self.isStrictSubset(of: other.rawValue)
  }

  public func isStrictSuperset(of other: NonEmpty<Self>) -> Bool {
    self.isStrictSuperset(of: other.rawValue)
  }
}
