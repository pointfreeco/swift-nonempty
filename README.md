# 🎁 NonEmpty

[![Swift 5](https://img.shields.io/badge/swift-5-ED523F.svg?style=flat)](https://swift.org/download/)
[![Linux CI](https://img.shields.io/travis/pointfreeco/swift-nonempty/master.svg?label=linux)](https://travis-ci.org/pointfreeco/swift-nonempty)
[![@pointfreeco](https://img.shields.io/badge/contact-@pointfreeco-5AA9E7.svg?style=flat)](https://twitter.com/pointfreeco)
<!-- [![iOS/macOS CI](https://img.shields.io/circleci/project/github/pointfreeco/swift-nonempty/master.svg?label=ios/macos)](https://circleci.com/gh/pointfreeco/swift-nonempty) -->

A compile-time guarantee that a collection contains a value.

## Motivation

We often work with collections that should _never_ be empty, but the type system makes no such guarantees, so we're forced to handle that empty case, often with `if` and `guard` statements. `NonEmpty` is a lightweight type that can transform _any_ collection type into a non-empty version. Some examples:

```swift
// 1.) A non-empty array of integers
let xs = NonEmpty<[Int]>(1, 2, 3, 4)
xs.first + 1 // `first` is non-optional since it's guaranteed to be present

// 2.) A non-empty set of integers
let ys = NonEmpty<Set<Int>>(1, 1, 2, 2, 3, 4)
ys.forEach { print($0) } // => 1, 2, 3, 4

// 3.) A non-empty dictionary of values
let zs = NonEmpty<[Int: String]>((1, "one"), [2: "two", 3: "three"])

// 4.) A non-empty string
let helloWorld = NonEmpty<String>("H", "ello World")
print("\(helloWorld)!") // "Hello World!"
```

## Applications

There are many applications of non-empty collection types but it can be hard to see since the Swift standard library does not give us this type. Here are just a few such applications:

### Strengthen 1st party APIs

Many APIs take and return empty-able arrays when they can in fact guarantee that the arrays are non-empty. Consider a `groupBy` function:

```swift
extension Sequence {
  func groupBy<A>(_ f: (Element) -> A) -> [A: [Element]] {
    // Unimplemented
  }
}

Array(1...10)
  .groupBy { $0 % 3 }
// [0: [3, 6, 9], 1: [1, 4, 7, 10], 2: [2, 5, 8]]
```

However, the array `[Element]` inside the return type `[A: [Element]]` can be guaranteed to never be empty, for the only way to produce an `A` is from an `Element`. Therefore the signature of this function could be strengthened to be:

```swift
extension Sequence {
  func groupBy<A>(_ f: (Element) -> A) -> [A: NonEmpty<[Element]>] {
    // Unimplemented
  }
}
```

### Better interface with 3rd party APIs

Sometimes a 3rd party API we interact with requires non-empty collections of values, and so in our code we should use non-empty types so that we can be sure to never send an empty values to the API. A good example of this is [GraphQL](https://graphql.org/). Here is a very simple query builder and printer:

```swift
enum UserField: String { case id, name, email }

func query(_ fields: Set<UserField>) -> String {
  return (["{"] + fields.map { "  \($0.rawValue)" } + ["}"])
    .joined()
}

print(query([.name, .email]))
// {
//   name
//   email
// }

print(query([]))
// {
// }
```

This last query is a programmer error, and will cause the GraphQL server to send back an error because it is not valid to send an empty query. We can prevent this from ever happening by instead forcing our query builder to work with non-empty sets:

```swift
func query(_ fields: NonEmptySet<UserField>) -> String {
  return (["{"] + fields.map { "  \($0.rawValue)" } + ["}"])
    .joined()
}

print(query(.init(.name, .email)))
// {
//   name
//   email
// }

print(query(.init()))
// 🛑 Does not compile
```

### More expressive data structures

A popular type in the Swift community (and other languages), is the `Result` type. It allows you to express a value that can be successful or be a failure. There's a related type that is also handy, called the `Validated` type:

```swift
enum Validated<Value, Error> {
  case valid(Value)
  case invalid([Error])
}
```

A value of type `Validated` is either valid, and hence comes with a `Value`, or it is invalid, and comes with an array of errors that describe what all is wrong with the value. For example:

```swift
let validatedPassword: Validated<String, String> =
  .invalid(["Password is too short.", "Password must contain at least one number."])
```

This is useful because it allows you to describe all of the things wrong with a value, not just one thing. However, it doesn't make a lot of sense if we use an empty array of the list of validation errors:

```swift
let validatedPassword: Validated<String, String> = .invalid([]) // ???
```

Instead, we should strengthen the `Validated` type to use a non-empty array:

```swift
enum Validated<Value, Error> {
  case valid(Value)
  case invalid(NonEmptyArray<Error>)
}
```

And now this is a compiler error:

```swift
let validatedPassword: Validated<String, String> = .invalid(.init([])) // 🛑
```

## Installation

### Carthage

If you use [Carthage](https://github.com/Carthage/Carthage), you can add the following dependency to your `Cartfile`:

``` ruby
github "pointfreeco/swift-nonempty" ~> 0.1.2
```

### CocoaPods

If your project uses [CocoaPods](https://cocoapods.org), just add the following to your `Podfile`:

``` ruby
pod 'NonEmpty', '~> 0.1.2'
```

### SwiftPM

If you want to use NonEmpty in a project that uses [SwiftPM](https://swift.org/package-manager/), it's as simple as adding a `dependencies` clause to your `Package.swift`:

``` swift
dependencies: [
  .package(url: "https://github.com/pointfreeco/swift-nonempty.git", from: "0.1.2")
]
```

### Xcode Sub-project

Submodule, clone, or download NonEmpty, and drag `NonEmpty.xcodeproj` into your project.

## Interested in learning more?

These concepts (and more) are explored thoroughly in [Point-Free](https://www.pointfree.co), a video series exploring functional programming and Swift hosted by [Brandon Williams](https://github.com/mbrandonw) and [Stephen Celis](https://github.com/stephencelis).

NonEmpty was first explored in [Episode #20](https://www.pointfree.co/episodes/ep20-nonempty):

<a href="https://www.pointfree.co/episodes/ep20-nonempty">
  <img alt="video poster image" src="https://d1hf1soyumxcgv.cloudfront.net/0020-nonempty/poster.jpg" width="480">
</a>

## License

All modules are released under the MIT license. See [LICENSE](LICENSE) for details.
