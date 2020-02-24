public typealias NonEmptySet<Element> = NonEmpty<Set<Element>> where Element: Hashable

// NB: `NonEmpty` does not conditionally conform to `SetAlgebra` because it contains destructive methods.
extension NonEmpty where C: SetAlgebra, C.Element: Hashable {
  public init(_ head: C.Element, _ tail: C.Element...) {
    var tail = C(tail)
    tail.insert(head)
    self.init(tail)!
  }

  public func contains(_ member: C.Element) -> Bool {
    self.rawValue.contains(member)
  }

  public func union(_ other: NonEmpty) -> NonEmpty {
    var copy = self
    copy.formUnion(other)
    return copy
  }

  public func union(_ other: C) -> NonEmpty {
    var copy = self
    copy.formUnion(other)
    return copy
  }

  public func intersection(_ other: NonEmpty) -> C {
    self.rawValue.intersection(other.rawValue)
  }

  public func intersection(_ other: C) -> C {
    self.rawValue.intersection(other)
  }

  public func symmetricDifference(_ other: NonEmpty) -> C {
    self.rawValue.symmetricDifference(other.rawValue)
  }

  public func symmetricDifference(_ other: C) -> C {
    self.rawValue.symmetricDifference(other)
  }

  @discardableResult
  public mutating func insert(_ newMember: C.Element) -> (inserted: Bool, memberAfterInsert: C.Element) {
    self.rawValue.insert(newMember)
  }

  @discardableResult
  public mutating func update(with newMember: C.Element) -> C.Element? {
    self.rawValue.update(with: newMember)
  }

  public mutating func formUnion(_ other: NonEmpty) {
    self.rawValue.formUnion(other.rawValue)
  }

  public mutating func formUnion(_ other: C) {
    self.rawValue.formUnion(other)
  }

  public func subtracting(_ other: NonEmpty) -> C {
    self.rawValue.subtracting(other.rawValue)
  }

  public func subtracting(_ other: C) -> C {
    self.rawValue.subtracting(other)
  }

  public func isDisjoint(with other: NonEmpty) -> Bool {
    self.rawValue.isDisjoint(with: other.rawValue)
  }

  public func isDisjoint(with other: C) -> Bool {
    self.rawValue.isDisjoint(with: other)
  }

  public func isSubset(of other: NonEmpty) -> Bool {
    self.rawValue.isSubset(of: other.rawValue)
  }

  public func isSubset(of other: C) -> Bool {
    self.rawValue.isSubset(of: other)
  }

  public func isSuperset(of other: NonEmpty) -> Bool {
    self.rawValue.isSuperset(of: other.rawValue)
  }

  public func isSuperset(of other: C) -> Bool {
    self.rawValue.isSuperset(of: other)
  }

  public func isStrictSubset(of other: NonEmpty) -> Bool {
    self.rawValue.isStrictSubset(of: other.rawValue)
  }

  public func isStrictSubset(of other: C) -> Bool {
    self.rawValue.isStrictSubset(of: other)
  }

  public func isStrictSuperset(of other: NonEmpty) -> Bool {
    self.rawValue.isStrictSuperset(of: other.rawValue)
  }

  public func isStrictSuperset(of other: C) -> Bool {
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
