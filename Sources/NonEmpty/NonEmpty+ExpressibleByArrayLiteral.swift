extension NonEmpty: ExpressibleByArrayLiteral where Collection: ExpressibleByArrayLiteral {
  public init(arrayLiteral elements: Element...) {
    precondition(!elements.isEmpty, "Can't construct \(Self.self) from empty array literal")
    let f = unsafeBitCast(
      Collection.init(arrayLiteral:),
      to: (([Element]) -> Collection).self
    )
    self.init(rawValue: f(elements))!
  }
}
