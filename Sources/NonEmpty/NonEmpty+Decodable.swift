public protocol NonEmptyDecodable: Decodable, Collection {
  init()
  mutating func append<S>(contentsOf newElements: S) where Element == S.Element, S : Sequence
}

public protocol NonEmptyEncodable: Encodable, Collection {
  init()
  mutating func append<S>(contentsOf newElements: S) where Element == S.Element, S : Sequence
}


public typealias NonEmptyCodable = NonEmptyDecodable & NonEmptyEncodable

public enum NonEmptyCodableError: Error, Equatable {
  case emptyCollection
}

extension Array: NonEmptyDecodable where Array.Element: Decodable {}
extension Array: NonEmptyEncodable where Array.Element: Encodable {}

extension String: NonEmptyDecodable {}
extension String: NonEmptyEncodable {}

extension Dictionary {
  /// Private shared implementation
  private mutating func append<S>(elements newElements: S) where S : Sequence, Dictionary.Element == S.Element {
    for (key, value) in newElements {
      self[key] = value
    }
  }

  public init() {
    self = [:]
  }
}

extension Dictionary: NonEmptyDecodable where Dictionary.Key: Decodable, Dictionary.Value: Decodable {
  public mutating func append<S>(contentsOf newElements: S) where S : Sequence, Dictionary.Element == S.Element {
    append(elements: newElements)
  }
}

extension Dictionary: NonEmptyEncodable where Dictionary.Key: Encodable, Dictionary.Value: Encodable {
  public mutating func append<S>(contentsOf newElements: S) where S : Sequence, Dictionary.Element == S.Element {
    append(elements: newElements)
  }
}

extension NonEmpty: Decodable where C: NonEmptyDecodable {
  public init(from decoder: Decoder) throws {
    let elements = try C(from: decoder)
    guard let head = elements.first else { throw NonEmptyCodableError.emptyCollection }
    let slice = elements.dropFirst()
    var tail = C()
    tail.append(contentsOf: slice)
    self.init(head, tail)
  }
}

extension NonEmpty: Encodable where C: NonEmptyEncodable {
  public func encode(to encoder: Encoder) throws {
    var full = C()
    full.append(contentsOf: [head])
    full.append(contentsOf: tail)
    try full.encode(to: encoder)
  }
}
