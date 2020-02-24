public typealias NonEmptyString = NonEmpty<String>

extension NonEmpty/*: StringProtocol*/ where C: StringProtocol {
  public func lowercased() -> NonEmptyString {
    NonEmptyString(self.rawValue.lowercased())!
  }

  public func uppercased() -> NonEmptyString {
    NonEmptyString(self.rawValue.uppercased())!
  }
}
