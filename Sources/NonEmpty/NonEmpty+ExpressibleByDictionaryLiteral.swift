extension NonEmpty: ExpressibleByDictionaryLiteral where Collection: _InitializableFromKeyValuePairs {
  public init(dictionaryLiteral elements: (Collection.Key, Collection.Value)...) {
    assert(!elements.isEmpty, "Cannot initialize a NonEmpty dictionary from an empty literal!")
    self.init(rawValue: Collection(uniqueKeysWithValues: elements))!
  }
}

public protocol _InitializableFromKeyValuePairs {
  associatedtype Key
  associatedtype Value

  init(uniqueKeysWithValues: [(Key, Value)])
}

extension Dictionary: _InitializableFromKeyValuePairs {}
