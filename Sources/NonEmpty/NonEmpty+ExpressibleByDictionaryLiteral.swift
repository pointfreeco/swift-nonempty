extension NonEmpty: ExpressibleByDictionaryLiteral
where Collection: ExpressibleByDictionaryLiteral {
  public init(dictionaryLiteral elements: (Collection.Key, Collection.Value)...) {
    precondition(!elements.isEmpty, "Can't construct \(Self.self) from empty dictionary literal")
    let f = unsafeBitCast(
      Collection.init(dictionaryLiteral:),
      to: (([(Collection.Key, Collection.Value)]) -> Collection).self
    )
    self.init(rawValue: f(elements))!
  }
}
