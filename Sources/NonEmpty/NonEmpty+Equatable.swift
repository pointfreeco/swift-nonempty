extension NonEmpty: Equatable where C: Equatable, C.Element: Equatable {
  public static func == (lhs: NonEmpty, rhs: NonEmpty) -> Bool {
    return lhs.head == rhs.head && lhs.tail == rhs.tail
  }
}
