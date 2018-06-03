#if swift(>=4.1.5)
extension NonEmpty {
  public func randomElement<T: RandomNumberGenerator>(using generator: inout T) -> Element {
    return ContiguousArray(self).randomElement(using: &generator) ?? self.head
  }

  public func randomElement() -> Element {
    return self.randomElement(using: &Random.default)
  }
}

extension NonEmpty where C: RangeReplaceableCollection {
  public mutating func shuffle<T: RandomNumberGenerator>(using generator: inout T) {
    let result = ContiguousArray(self).shuffled(using: &generator)
    self.head = result.first ?? self.head
    self.tail = C(result.dropFirst())
  }

  public mutating func shuffle() {
    self.shuffle(using: &Random.default)
  }

  public func shuffled<T: RandomNumberGenerator>(using generator: inout T) -> NonEmpty {
    var copy = self
    copy.shuffle(using: &generator)
    return copy
  }

  public func shuffled() -> NonEmpty {
    return self.shuffled(using: &Random.default)
  }
}
#endif
