extension NonEmpty: MutableCollection where C: MutableCollection {
  public subscript(position: Index) -> Element {
    get {
      switch position {
      case .head:
        return self.head
      case let .tail(index):
        return self.tail[index]
      }
    }
    set {
      switch position {
      case .head:
        self.head = newValue
      case let .tail(index):
        self.tail[index] = newValue
      }
    }
  }
}

extension NonEmpty where C: MutableCollection, C.Index == Int {
  public subscript(position: Int) -> Element {
    get {
      return self[position == 0 ? .head : .tail(position - 1)]
    }
    set {
      assert(self.tail.startIndex == 0)
      self[position == 0 ? .head : .tail(position - 1)] = newValue
    }
  }
}


extension NonEmpty where C.SubSequence == C, C.Index == Int {
  public subscript(position: Int) -> Element {
    get {
      assert(self.tail.startIndex == 0, message)
      return self[position == 0 ? .head : .tail(position - 1)]
    }
  }
}

private let message = """
Non-zero based indices are not valid for non-empty subsequences. You may have run into this by making a
non-empty `ArraySlice`. Don't do that.
"""

extension NonEmpty where C: MutableCollection, C.SubSequence == C, C.Index == Int {
  public subscript(position: Int) -> Element {
    get {
      assert(self.tail.startIndex == 0, message)
      return self[position == 0 ? .head : .tail(position - 1)]
    }
    set {
      assert(self.tail.startIndex == 0, message)
      self[position == 0 ? .head : .tail(position - 1)] = newValue
    }
  }
}
