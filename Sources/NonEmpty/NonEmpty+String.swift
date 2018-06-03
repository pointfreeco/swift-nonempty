public typealias NonEmptyString = NonEmpty<String>

extension NonEmpty where C == String {
  public init(_ head: Character) {
    self.init(head, "")
  }

  public func lowercased() -> NonEmptyString {
    return NonEmpty(String(self.head).lowercased().first!, self.tail.lowercased())
  }

  public func uppercased() -> NonEmptyString {
    return NonEmpty(String(self.head).uppercased().first!, self.tail.uppercased())
  }

  public init<S: LosslessStringConvertible>(_ value: S) {
    let string = String(value)
    self.init(string.first!, String(string.dropFirst()))
  }

  public var string: String {
    return String(self.head) + self.tail
  }
}
