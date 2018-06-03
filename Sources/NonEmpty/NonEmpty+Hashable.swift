extension NonEmpty: Hashable where C: Hashable, C.Element: Hashable {
  #if swift(>=4.1.5)
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.head)
    hasher.combine(self.tail)
  }
  #else
  public var hashValue: Int {
    return self.head.hashValue ^ self.tail.hashValue
  }
  #endif
}
