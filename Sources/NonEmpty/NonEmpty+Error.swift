extension NonEmpty {

  enum Error: Swift.Error, CustomStringConvertible {

    case emptyCollection

    var description: String {
      switch self {
      case .emptyCollection:
        return "Non-empty collection expected"
      }
    }

  }

}
