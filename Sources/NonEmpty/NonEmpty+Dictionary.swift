public typealias NonEmptyDictionary<Key, Value> = NonEmpty<[Key: Value]> where Key: Hashable

public protocol _DictionaryProtocol: Collection where Element == (key: Key, value: Value) {
  associatedtype Key: Hashable
  associatedtype Value
  var keys: Dictionary<Key, Value>.Keys { get }
  subscript(key: Key) -> Value? { get set }
  mutating func merge<S: Sequence>(
    _ other: S, uniquingKeysWith combine: (Value, Value) throws -> Value
  ) rethrows where S.Element == (Key, Value)
  mutating func merge(
    _ other: [Key: Value], uniquingKeysWith combine: (Value, Value) throws -> Value
  ) rethrows
  @discardableResult mutating func removeValue(forKey key: Key) -> Value?
  @discardableResult mutating func updateValue(_ value: Value, forKey key: Key) -> Value?
}

extension Dictionary: _DictionaryProtocol {}

extension NonEmpty where Collection: _DictionaryProtocol {
  public init(_ head: Element, _ tail: Collection) {
    guard !tail.keys.contains(head.key) else { fatalError("Dictionary contains duplicate key") }
    var tail = tail
    tail[head.key] = head.value
    self.init(rawValue: tail)!
  }

  public init(
    _ head: Element,
    _ tail: Collection,
    uniquingKeysWith combine: (Collection.Value, Collection.Value) throws -> Collection.Value
  ) rethrows {

    var tail = tail
    if let otherValue = tail.removeValue(forKey: head.0) {
      tail[head.key] = try combine(head.value, otherValue)
    } else {
      tail[head.key] = head.value
    }
    self.init(rawValue: tail)!
  }

  public subscript(key: Collection.Key) -> Collection.Value? {
    self.rawValue[key]
  }

  public mutating func merge<S: Sequence>(
    _ other: S,
    uniquingKeysWith combine: (Collection.Value, Collection.Value) throws -> Collection.Value
  ) rethrows where S.Element == (Collection.Key, Collection.Value) {

    try self.rawValue.merge(other, uniquingKeysWith: combine)
  }

  public func merging<S: Sequence>(
    _ other: S,
    uniquingKeysWith combine: (Collection.Value, Collection.Value) throws -> Collection.Value
  ) rethrows -> NonEmpty where S.Element == (Collection.Key, Collection.Value) {

    var copy = self
    try copy.merge(other, uniquingKeysWith: combine)
    return copy
  }

  public mutating func merge(
    _ other: [Collection.Key: Collection.Value],
    uniquingKeysWith combine: (Collection.Value, Collection.Value) throws -> Collection.Value
  ) rethrows {

    try self.rawValue.merge(other, uniquingKeysWith: combine)
  }

  public func merging(
    _ other: [Collection.Key: Collection.Value],
    uniquingKeysWith combine: (Collection.Value, Collection.Value) throws -> Collection.Value
  ) rethrows -> NonEmpty {

    var copy = self
    try copy.merge(other, uniquingKeysWith: combine)
    return copy
  }

  @discardableResult
  public mutating func updateValue(_ value: Collection.Value, forKey key: Collection.Key)
    -> Collection.Value?
  {
    self.rawValue.updateValue(value, forKey: key)
  }
}

extension NonEmpty where Collection: _DictionaryProtocol, Collection.Value: Equatable {
  public static func == (lhs: NonEmpty, rhs: NonEmpty) -> Bool {
    return Dictionary(uniqueKeysWithValues: Array(lhs))
      == Dictionary(uniqueKeysWithValues: Array(rhs))
  }
}

extension NonEmpty where Collection: _DictionaryProtocol & ExpressibleByDictionaryLiteral {
  public init(_ head: Element) {
    self.init(rawValue: [head.key: head.value])!
  }
}
