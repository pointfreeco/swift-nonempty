import NonEmpty

let xs = NonEmptyArray(42, 1, 3, 2)

let str: NonEmptyString = xs
  .sorted()
  .map { NonEmptyString($0)! }
  .joined(separator: ",")
