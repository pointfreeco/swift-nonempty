public typealias NonEmptyString = NonEmpty<String>

extension NonEmpty: ExpressibleByUnicodeScalarLiteral where C: ExpressibleByUnicodeScalarLiteral {
  public typealias UnicodeScalarLiteralType = C.UnicodeScalarLiteralType

  public init(unicodeScalarLiteral value: C.UnicodeScalarLiteralType) {
    self.init(rawValue: C(unicodeScalarLiteral: value))!
  }
}

extension NonEmpty: ExpressibleByExtendedGraphemeClusterLiteral where C: ExpressibleByExtendedGraphemeClusterLiteral {
  public typealias ExtendedGraphemeClusterLiteralType = C.ExtendedGraphemeClusterLiteralType

  public init(extendedGraphemeClusterLiteral value: C.ExtendedGraphemeClusterLiteralType) {
    self.init(rawValue: C(extendedGraphemeClusterLiteral: value))!
  }
}

extension NonEmpty: ExpressibleByStringLiteral where C: ExpressibleByStringLiteral {
  public typealias StringLiteralType = C.StringLiteralType

  public init(stringLiteral value: C.StringLiteralType) {
    self.init(rawValue: C(stringLiteral: value))!
  }
}

extension NonEmpty: TextOutputStreamable where C: TextOutputStreamable {
  public func write<Target>(to target: inout Target) where Target : TextOutputStream {
    self.rawValue.write(to: &target)
  }
}

extension NonEmpty: TextOutputStream where C: TextOutputStream {
  public mutating func write(_ string: String) {
    self.rawValue.write(string)
  }
}

extension NonEmpty: LosslessStringConvertible where C: LosslessStringConvertible {
  public init?(_ description: String) {
    guard let string = C(description) else { return nil }
    self.init(rawValue: string)
  }
}

extension NonEmpty: ExpressibleByStringInterpolation where C: ExpressibleByStringInterpolation, C.StringLiteralType == DefaultStringInterpolation.StringLiteralType {}

#if swift(>=5.2)
extension NonEmpty: StringProtocol where C: StringProtocol {
  public typealias UTF8View = C.UTF8View
  public typealias UTF16View = C.UTF16View
  public typealias UnicodeScalarView = C.UnicodeScalarView

  public var utf8: UTF8View { self.rawValue.utf8 }
  public var utf16: UTF16View { self.rawValue.utf16 }
  public var unicodeScalars: UnicodeScalarView { self.rawValue.unicodeScalars }

  public func lowercased() -> String { self.rawValue.lowercased() }
  public func uppercased() -> String { self.rawValue.uppercased() }

  public init<CodeUnits, Encoding>(
    decoding codeUnits: CodeUnits, as sourceEncoding: Encoding.Type
  ) where CodeUnits: Collection, Encoding: _UnicodeEncoding, CodeUnits.Element == Encoding.CodeUnit {
    self.init(rawValue: C(decoding: codeUnits, as: sourceEncoding))!
  }

  public init(cString nullTerminatedUTF8: UnsafePointer<CChar>) {
    self.init(rawValue: C(cString: nullTerminatedUTF8))!
  }

  public init<Encoding>(
    decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>,
    as sourceEncoding: Encoding.Type
  ) where Encoding: _UnicodeEncoding {
    self.init(rawValue: C(decodingCString: nullTerminatedCodeUnits, as: sourceEncoding))!
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
extension NonEmpty where C: StringProtocol {
  public typealias UTF8View = C.UTF8View
  public typealias UTF16View = C.UTF16View
  public typealias UnicodeScalarView = C.UnicodeScalarView

  public var utf8: UTF8View { self.rawValue.utf8 }
  public var utf16: UTF16View { self.rawValue.utf16 }
  public var unicodeScalars: UnicodeScalarView { self.rawValue.unicodeScalars }

  public func lowercased() -> String { self.rawValue.lowercased() }
  public func uppercased() -> String { self.rawValue.uppercased() }

  public init<CodeUnits, Encoding>(
    decoding codeUnits: CodeUnits, as sourceEncoding: Encoding.Type
  ) where CodeUnits: Collection, Encoding: _UnicodeEncoding, CodeUnits.Element == Encoding.CodeUnit {
    self.init(rawValue: C(decoding: codeUnits, as: sourceEncoding))!
  }

  public init(cString nullTerminatedUTF8: UnsafePointer<CChar>) {
    self.init(rawValue: C(cString: nullTerminatedUTF8))!
  }

  public init<Encoding>(
    decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>,
    as sourceEncoding: Encoding.Type
  ) where Encoding: _UnicodeEncoding {
    self.init(rawValue: C(decodingCString: nullTerminatedCodeUnits, as: sourceEncoding))!
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
