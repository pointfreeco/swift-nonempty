import NonEmpty

let xs = NonEmptyArray(42, 1, 3, 2)

xs + xs

NonEmptyString.init("")

let x: Character = ""

xs
  .sorted()
  .map(NonEmptyString.init)
  .joined(separator: ",")


let names: [NonEmptyString] = [
  .init("B", "lob"),
  .init("J", "ill"),
  .init("J", "ack"),
  .init("N", "oether"),
  .init("G", "alois")
]

extension Sequence {
  func groupBy<A: Hashable>(_ f: (Element) -> A) -> [A: NonEmpty<[Element]>] {
    var result: [A: NonEmpty<[Element]>] = [:]
    for element in self {
      let key = f(element)
      if result[key] == nil {
        result[key] = NonEmpty(element)
      } else {
        result[key]?.append(element)
      }
    }
    return result
  }
}

names
  .groupBy { $0.safeFirst }
  .forEach { key, value in
    print(key)
    value.forEach { print("  ", $0) }
}

//names.gr
