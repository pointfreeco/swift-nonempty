public struct NonEmpty<C: Collection> {
  public typealias Element = C.Element

  public internal(set) var head: Element
  public internal(set) var tail: C

  public init(_ head: Element, _ tail: C) {
    self.head = head
    self.tail = tail
  }
}

extension NonEmpty: CustomStringConvertible {
  public var description: String {
    return "\(self.head)\(self.tail)"
  }
}

extension NonEmpty: Equatable where C: Equatable, C.Element: Equatable {}

extension NonEmpty: Hashable where C: Hashable, C.Element: Hashable {}

extension NonEmpty: Decodable where C: Decodable, C.Element: Decodable {}

extension NonEmpty: Encodable where C: Encodable, C.Element: Encodable {}
