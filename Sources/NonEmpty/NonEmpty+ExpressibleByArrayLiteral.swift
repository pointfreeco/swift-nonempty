extension NonEmpty: ExpressibleByArrayLiteral where Collection: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Element...) {
    assert(!elements.isEmpty, "Cannot initialize a NonEmpty array from an empty literal!")
    let f = unsafeBitCast(
      Collection.init(arrayLiteral:),
      to: (([Element]) -> Collection).self
    )
    self.init(rawValue: f(elements))!
  }
}
