extension NonEmpty: ExpressibleByDictionaryLiteral where Collection: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (Collection.Key, Collection.Value)...) {
    assert(!elements.isEmpty, "Cannot initialize a NonEmpty dictionary from an empty literal!")
    let f = unsafeBitCast(
      Collection.init(dictionaryLiteral:),
      to: (([(Collection.Key, Collection.Value)]) -> Collection).self
    )
    self.init(rawValue: f(elements))!
  }
}
