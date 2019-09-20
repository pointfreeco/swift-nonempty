public protocol NonEmptyDecodable: Decodable, Collection {
  static func foldFromNonEmpty(slice: Self.SubSequence) -> Self
}

public protocol NonEmptyEncodable: Encodable, Collection {
  static func foldFromNonEmpty(head: Self.Element, tail: Self) -> Self
}

public typealias NonEmptyCodable = NonEmptyDecodable & NonEmptyEncodable

public enum NonEmptyCodableError: Error, Equatable {
  case emptyCollection
}

extension Array: NonEmptyDecodable where Array.Element: Decodable {
  public static func foldFromNonEmpty(slice: SubSequence) -> Array {
    return .init(slice)
  }
}
extension Array: NonEmptyEncodable where Array.Element: Encodable {
  public static func foldFromNonEmpty(head: Element, tail: Array) -> Array {
    var full = [head]
    full.append(contentsOf: tail)
    return full
  }
}

extension String: NonEmptyDecodable {
  public static func foldFromNonEmpty(slice: Substring) -> String {
    return .init(slice)
  }
}
extension String: NonEmptyEncodable {
  public static func foldFromNonEmpty(head: Character, tail: String) -> String {
    return "\(head)\(tail)"
  }
}

extension Dictionary: NonEmptyDecodable where Dictionary.Key: Decodable, Dictionary.Value: Decodable {
	public static func foldFromNonEmpty(slice: SubSequence) -> Dictionary {
    return slice.reduce(into: Dictionary()) { dict, entry in
      dict[entry.key] = entry.value
    }
  }
}

extension Dictionary: NonEmptyEncodable where Dictionary.Key: Encodable, Dictionary.Value: Encodable {
  public static func foldFromNonEmpty(head: Element, tail: Dictionary) -> Dictionary {
    var copy = tail
    copy[head.key] = head.value
    return copy
	}
}

extension NonEmpty: Decodable where C: NonEmptyDecodable {
  public init(from decoder: Decoder) throws {
    let elements = try C(from: decoder)
    guard let head = elements.first else { throw NonEmptyCodableError.emptyCollection }
    let tail = C.foldFromNonEmpty(slice: elements.dropFirst())
    self.init(head, tail)
  }
}

extension NonEmpty: Encodable where C: NonEmptyEncodable {
  public func encode(to encoder: Encoder) throws {
    let full = C.foldFromNonEmpty(head: head, tail: tail)
    try full.encode(to: encoder)
  }
}
