public typealias NonEmptyString = NonEmpty<String>

extension NonEmpty: ExpressibleByUnicodeScalarLiteral where Collection: ExpressibleByUnicodeScalarLiteral {
  public typealias UnicodeScalarLiteralType = Collection.UnicodeScalarLiteralType

  public init(unicodeScalarLiteral value: Collection.UnicodeScalarLiteralType) {
    self.init(rawValue: Collection(unicodeScalarLiteral: value))!
  }
}

extension NonEmpty: ExpressibleByExtendedGraphemeClusterLiteral where Collection: ExpressibleByExtendedGraphemeClusterLiteral {
  public typealias ExtendedGraphemeClusterLiteralType = Collection.ExtendedGraphemeClusterLiteralType

  public init(extendedGraphemeClusterLiteral value: Collection.ExtendedGraphemeClusterLiteralType) {
    self.init(rawValue: Collection(extendedGraphemeClusterLiteral: value))!
  }
}

extension NonEmpty: ExpressibleByStringLiteral where Collection: ExpressibleByStringLiteral {
  public typealias StringLiteralType = Collection.StringLiteralType

  public init(stringLiteral value: Collection.StringLiteralType) {
    self.init(rawValue: Collection(stringLiteral: value))!
  }
}

extension NonEmpty: TextOutputStreamable where Collection: TextOutputStreamable {
  public func write<Target>(to target: inout Target) where Target : TextOutputStream {
    self.rawValue.write(to: &target)
  }
}

extension NonEmpty: TextOutputStream where Collection: TextOutputStream {
  public mutating func write(_ string: String) {
    self.rawValue.write(string)
  }
}

extension NonEmpty: LosslessStringConvertible where Collection: LosslessStringConvertible {
  public init?(_ description: String) {
    guard let string = Collection(description) else { return nil }
    self.init(rawValue: string)
  }
}

extension NonEmpty: ExpressibleByStringInterpolation where Collection: ExpressibleByStringInterpolation, Collection.StringLiteralType == DefaultStringInterpolation.StringLiteralType {}

#if swift(>=5.2)
extension NonEmpty: StringProtocol where Collection: StringProtocol {
  public typealias UTF8View = Collection.UTF8View
  public typealias UTF16View = Collection.UTF16View
  public typealias UnicodeScalarView = Collection.UnicodeScalarView

  public var utf8: UTF8View { self.rawValue.utf8 }
  public var utf16: UTF16View { self.rawValue.utf16 }
  public var unicodeScalars: UnicodeScalarView { self.rawValue.unicodeScalars }

  public func lowercased() -> String { self.rawValue.lowercased() }
  public func uppercased() -> String { self.rawValue.uppercased() }

  public init<C, Encoding>(
    decoding codeUnits: C, as sourceEncoding: Encoding.Type
  ) where C: Swift.Collection, Encoding: _UnicodeEncoding, C.Element == Encoding.CodeUnit {
    self.init(rawValue: Collection(decoding: codeUnits, as: sourceEncoding))!
  }

  public init(cString nullTerminatedUTF8: UnsafePointer<CChar>) {
    self.init(rawValue: Collection(cString: nullTerminatedUTF8))!
  }

  public init<Encoding>(
    decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>,
    as sourceEncoding: Encoding.Type
  ) where Encoding: _UnicodeEncoding {
    self.init(rawValue: Collection(decodingCString: nullTerminatedCodeUnits, as: sourceEncoding))!
  }

  public func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result {
    try self.rawValue.withCString(body)
  }

  public func withCString<Result, Encoding>(
    encodedAs targetEncoding: Encoding.Type,
    _ body: (UnsafePointer<Encoding.CodeUnit>) throws -> Result
  ) rethrows -> Result where Encoding: _UnicodeEncoding {
    try self.withCString(encodedAs: targetEncoding, body)
  }

  public func lowercased() -> NonEmptyString {
    NonEmptyString(self.rawValue.lowercased())!
  }

  public func uppercased() -> NonEmptyString {
    NonEmptyString(self.rawValue.uppercased())!
  }
}
#else
extension NonEmpty where Collection: StringProtocol {
  public typealias UTF8View = Collection.UTF8View
  public typealias UTF16View = Collection.UTF16View
  public typealias UnicodeScalarView = Collection.UnicodeScalarView

  public var utf8: UTF8View { self.rawValue.utf8 }
  public var utf16: UTF16View { self.rawValue.utf16 }
  public var unicodeScalars: UnicodeScalarView { self.rawValue.unicodeScalars }

  public func lowercased() -> String { self.rawValue.lowercased() }
  public func uppercased() -> String { self.rawValue.uppercased() }

  public init<C, Encoding>(
    decoding codeUnits: C, as sourceEncoding: Encoding.Type
  ) where C: Collection, Encoding: _UnicodeEncoding, C.Element == Encoding.CodeUnit {
    self.init(rawValue: Collection(decoding: codeUnits, as: sourceEncoding))!
  }

  public init(cString nullTerminatedUTF8: UnsafePointer<CChar>) {
    self.init(rawValue: Collection(cString: nullTerminatedUTF8))!
  }

  public init<Encoding>(
    decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>,
    as sourceEncoding: Encoding.Type
  ) where Encoding: _UnicodeEncoding {
    self.init(rawValue: Collection(decodingCString: nullTerminatedCodeUnits, as: sourceEncoding))!
  }

  public func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result {
    try self.rawValue.withCString(body)
  }

  public func withCString<Result, Encoding>(
    encodedAs targetEncoding: Encoding.Type,
    _ body: (UnsafePointer<Encoding.CodeUnit>) throws -> Result
  ) rethrows -> Result where Encoding: _UnicodeEncoding {
    try self.withCString(encodedAs: targetEncoding, body)
  }

  public func lowercased() -> NonEmptyString {
    NonEmptyString(self.rawValue.lowercased())!
  }

  public func uppercased() -> NonEmptyString {
    NonEmptyString(self.rawValue.uppercased())!
  }
}
#endif
