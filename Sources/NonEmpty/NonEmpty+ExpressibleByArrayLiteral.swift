extension NonEmpty: ExpressibleByArrayLiteral where Collection: _InitializableFromArray {
  public init(arrayLiteral elements: Element...) {
    assert(!elements.isEmpty, "Cannot initialize a NonEmpty array from an empty literal!")
    self.init(rawValue: Collection(elements))!
  }
}

public protocol _InitializableFromArray {
  associatedtype Element

  init(_ array: [Element])
}

extension Array: _InitializableFromArray {}
