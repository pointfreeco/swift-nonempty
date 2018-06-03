public typealias NonEmptySet<Element> = NonEmpty<Set<Element>> where Element: Hashable & Comparable

extension NonEmpty where C: SetAlgebra, C.Element: Hashable & Comparable {
  public init(_ head: Element, _ tail: C) {
    var tail = tail
    tail.insert(head)
    self.head = tail.min() ?? head 
    tail.remove(self.head)
    self.tail = tail
  }

  public init(_ head: Element, _ tail: Element...) {
    self.init(head, C(tail))
  }

  public func contains(_ member: Element) -> Bool {
    var tail = self.tail
    tail.insert(self.head)
    return tail.contains(member)
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
    var tail = self.tail
    tail.insert(self.head)
    var otherTail = other.tail
    otherTail.insert(other.head)
    return tail.intersection(otherTail)
  }

  public func intersection(_ other: C) -> C {
    var tail = self.tail
    tail.insert(self.head)
    return tail.intersection(other)
  }

  public func symmetricDifference(_ other: NonEmpty) -> C {
    var tail = self.tail
    tail.insert(self.head)
    var otherTail = other.tail
    otherTail.insert(other.head)
    return tail.symmetricDifference(otherTail)
  }

  public func symmetricDifference(_ other: C) -> C {
    var tail = self.tail
    tail.insert(self.head)
    return tail.symmetricDifference(other)
  }

  @discardableResult
  public mutating func insert(_ newMember: Element)
    -> (inserted: Bool, memberAfterInsert: Element) {

      var newMember = newMember
      if newMember < self.head {
        (self.head, newMember) = (newMember, self.head)
      }
      var (inserted, memberAfterInsert) = self.tail.insert(newMember)
      if let _ = self.tail.remove(self.head) {
        (inserted, self.head) = (false, memberAfterInsert)
      }
      return (inserted, memberAfterInsert)
  }

// TODO: Implement
//  @discardableResult
//  public mutating func update(with newMember: Collection.Element) -> Collection.Element? {
//    fatalError()
//  }

  public mutating func formUnion(_ other: NonEmpty) {
    self.tail.insert(self.head)
    self.tail.insert(other.head)
    self.tail.formUnion(other.tail)
    self.head = tail.min() ?? self.head
    self.tail.remove(self.head)
  }

  public mutating func formUnion(_ other: C) {
    self.tail.insert(self.head)
    self.tail.formUnion(other)
    self.head = tail.min() ?? self.head
    self.tail.remove(self.head)
  }

  public func subtracting(_ other: NonEmpty) -> C {
    var tail = self.tail
    tail.insert(self.head)
    tail.remove(other.head)
    return tail.subtracting(other.tail)
  }

  public func subtracting(_ other: C) -> C {
    var tail = self.tail
    tail.insert(self.head)
    return tail.subtracting(other)
  }

  public func isDisjoint(with other: NonEmpty) -> Bool {
    var (tail, otherTail) = (self.tail, other.tail)
    tail.insert(self.head)
    otherTail.insert(other.head)
    return tail.isDisjoint(with: otherTail)
  }

  public func isDisjoint(with other: C) -> Bool {
    var tail = self.tail
    tail.insert(self.head)
    return tail.isDisjoint(with: other)
  }

  public func isSubset(of other: NonEmpty) -> Bool {
    var (tail, otherTail) = (self.tail, other.tail)
    tail.insert(self.head)
    otherTail.insert(other.head)
    return tail.isSubset(of: otherTail)
  }

  public func isSubset(of other: C) -> Bool {
    var tail = self.tail
    tail.insert(self.head)
    return tail.isSubset(of: other)
  }

  public func isSuperset(of other: NonEmpty) -> Bool {
    var (tail, otherTail) = (self.tail, other.tail)
    tail.insert(self.head)
    otherTail.insert(other.head)
    return tail.isSuperset(of: otherTail)
  }

  public func isSuperset(of other: C) -> Bool {
    var tail = self.tail
    tail.insert(self.head)
    return tail.isSuperset(of: other)
  }

  public func isStrictSubset(of other: NonEmpty) -> Bool {
    var (tail, otherTail) = (self.tail, other.tail)
    tail.insert(self.head)
    otherTail.insert(other.head)
    return tail.isStrictSubset(of: otherTail)
  }

  public func isStrictSubset(of other: C) -> Bool {
    var tail = self.tail
    tail.insert(self.head)
    return tail.isStrictSubset(of: other)
  }

  public func isStrictSuperset(of other: NonEmpty) -> Bool {
    var (tail, otherTail) = (self.tail, other.tail)
    tail.insert(self.head)
    otherTail.insert(other.head)
    return tail.isStrictSuperset(of: otherTail)
  }

  public func isStrictSuperset(of other: C) -> Bool {
    var tail = self.tail
    tail.insert(self.head)
    return tail.isStrictSuperset(of: other)
  }
}
