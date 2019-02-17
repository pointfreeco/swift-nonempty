public protocol NonEmptyDecodable: Decodable, Collection {
	init<S>(_ slice: S) where S : Sequence, S.Element == Element
}

public protocol NonEmptyEncodable: Encodable, Collection {
	init<S>(_ slice: S) where S : Sequence, S.Element == Element
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

private extension Dictionary {
    /// Private shared implementation
	init<S>(slice: S) where S : Sequence, Dictionary<Key, Value>.Element == S.Element {
		var temp = [Key: Value](minimumCapacity: slice.underestimatedCount)
		for (key, value) in slice {
			temp.updateValue(value, forKey: key)
		}
		self = temp
	}
}

extension Dictionary: NonEmptyDecodable where Dictionary.Key: Decodable, Dictionary.Value: Decodable {
  public init<S>(_ slice: S) where S : Sequence, Dictionary<Key, Value>.Element == S.Element {
        self.init(slice: slice)
    }
}

extension Dictionary: NonEmptyEncodable where Dictionary.Key: Encodable, Dictionary.Value: Encodable {
    public init<S>(_ slice: S) where S : Sequence, Dictionary<Key, Value>.Element == S.Element {
        self.init(slice: slice)
    }

    public mutating func append<S>(contentsOf newElements: S) where S : Sequence, Dictionary.Element == S.Element {
        for (key, value) in newElements {
            self[key] = value
        }
    }
}

extension NonEmpty: Decodable where C: NonEmptyDecodable {
	public init(from decoder: Decoder) throws {
		let elements = try C(from: decoder)
		guard let head = elements.first else { throw NonEmptyCodableError.emptyCollection }
		let slice = elements.dropFirst()
		let tail = C(slice)
		self.init(head, tail)
	}
}

extension NonEmpty: Encodable where C: NonEmptyEncodable {
	public func encode(to encoder: Encoder) throws {
		var full = C([head])
		full.append(contentsOf: tail)
		try full.encode(to: encoder)
	}
}
