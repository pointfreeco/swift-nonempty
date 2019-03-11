public typealias NonEmptyDictionary<Key, Value> = NonEmpty<[Key: Value]> where Key: Hashable

public protocol _DictionaryProtocol: Collection where Element == (key: Key, value: Value) {
  associatedtype Key: Hashable
  associatedtype Value
  var keys: Dictionary<Key, Value>.Keys { get }
  subscript(key: Key) -> Value? { get }
  mutating func merge<S: Sequence>(
    _ other: S, uniquingKeysWith combine: (Value, Value) throws -> Value
    ) rethrows where S.Element == (Key, Value)
  mutating func merge(
    _ other: [Key: Value], uniquingKeysWith combine: (Value, Value) throws -> Value
    ) rethrows
  @discardableResult mutating func removeValue(forKey key: Key) -> Value?
  mutating func updateValue(_ value: Value, forKey key: Key) -> Value?
}

extension Dictionary: _DictionaryProtocol {}

extension NonEmpty where C: _DictionaryProtocol {
  public init(_ head: Element, _ tail: C) {
    guard !tail.keys.contains(head.0) else { fatalError("Dictionary contains duplicate key") }
    self.head = head
    self.tail = tail
  }

  public init(
    _ head: Element,
    _ tail: C,
    uniquingKeysWith combine: (C.Value, C.Value) throws -> C.Value
    )
    rethrows {

      var tail = tail
      if let otherValue = tail.removeValue(forKey: head.0) {
        self.head = (head.0, try combine(head.1, otherValue))
      } else {
        self.head = head
      }
      self.tail = tail
  }

  public subscript(key: C.Key) -> C.Value? {
    return self.head.0 == key ? self.head.1 : self.tail[key]
  }

  public mutating func merge<S: Sequence>(
    _ other: S,
    uniquingKeysWith combine: (C.Value, C.Value) throws -> C.Value
    ) rethrows
    where S.Element == (C.Key, C.Value) {

      if let otherValue = other.first(where: { key, _ in key == self.head.0 })?.1 {
        self.head.1 = try combine(self.head.1, otherValue)
      }
      try self.tail.merge(other, uniquingKeysWith: combine)
  }

  public func merging<S: Sequence>(
    _ other: S,
    uniquingKeysWith combine: (C.Value, C.Value) throws -> C.Value
    ) rethrows
    -> NonEmpty
    where S.Element == (C.Key, C.Value) {

      var copy = self
      try copy.merge(other, uniquingKeysWith: combine)
      return copy
  }

  public mutating func merge(
    _ other: [C.Key: C.Value],
    uniquingKeysWith combine: (C.Value, C.Value) throws -> C.Value
    ) rethrows {

    var other = other
    if let otherValue = other.removeValue(forKey: self.head.0) {
      self.head.1 = try combine(self.head.1, otherValue)
    }
    try self.tail.merge(other, uniquingKeysWith: combine)
  }

  public func merging(
    _ other: [C.Key: C.Value],
    uniquingKeysWith combine: (C.Value, C.Value) throws -> C.Value
    ) rethrows
    -> NonEmpty {

      var copy = self
      try copy.merge(other, uniquingKeysWith: combine)
      return copy
  }

  public mutating func updateValue(_ value: C.Value, forKey key: C.Key)
    -> C.Value? {

      if head.0 == key {
        let oldValue = head.1
        head.1 = value
        return oldValue
      } else {
        return tail.updateValue(value, forKey: key)
      }
  }
}

extension NonEmpty where C: _DictionaryProtocol, C.Value: Equatable {
  public static func == (lhs: NonEmpty, rhs: NonEmpty) -> Bool {
    return Dictionary(uniqueKeysWithValues: Array(lhs))
      == Dictionary(uniqueKeysWithValues: Array(rhs))
  }
}

extension NonEmpty where C: _DictionaryProtocol & ExpressibleByDictionaryLiteral {
  public init(_ head: Element) {
    self.head = head
    self.tail = [:]
  }
}
