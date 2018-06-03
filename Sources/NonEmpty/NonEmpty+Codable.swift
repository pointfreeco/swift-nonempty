private enum CodingKeys: String, CodingKey {
  case head
  case tail
}

extension NonEmpty: Decodable where C: Decodable, C.Element: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.head = try container.decode(C.Element.self, forKey: .head)
    self.tail = try container.decode(C.self, forKey: .tail)
  }
}

extension NonEmpty: Encodable where C: Encodable, C.Element: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.head, forKey: .head)
    try container.encode(self.tail, forKey: .tail)
  }
}
