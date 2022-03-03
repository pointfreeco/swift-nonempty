extension NonEmpty {

  enum Error: Swift.Error, CustomStringConvertible {

    case emptyCollection
    case tooFewElements(expected: Int)
    
    var description: String {
      switch self {
      case .emptyCollection:
        return "Non-empty collection expected"
      case let .tooFewElements(expected):
        return "Expected at least \(expected) element\(expected > 1 ? "s" : "")"
      }
    }

  }

}
