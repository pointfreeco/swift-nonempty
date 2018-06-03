import NonEmpty

let xs = NonEmptyArray(42, 1, 3, 2)

xs
  .sorted()
  .map(NonEmptyString.init)
  .joined(separator: ",")
