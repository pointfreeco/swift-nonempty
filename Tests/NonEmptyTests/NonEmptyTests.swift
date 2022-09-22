import XCTest

@testable import NonEmpty

#if canImport(SwiftUI)
  import SwiftUI
#endif

final class NonEmptyTests: XCTestCase {
  func testCollection() {
    let xs = NonEmptyArray(1, 2, 3)

    XCTAssertEqual(3, xs.count)
    XCTAssertEqual(2, xs.first + 1)
    XCTAssertEqual(
      xs,
      NonEmptyArray(NonEmptyArray(1), NonEmptyArray(2), NonEmptyArray(3)).flatMap { $0 }
    )
    XCTAssertEqual(
      NonEmptyArray("1", "2", "3"),
      xs.map(String.init)
    )
    XCTAssertEqual(4, xs.min(by: >) + 1)
    XCTAssertEqual(2, xs.max(by: >) + 1)
    XCTAssertEqual(NonEmptyArray(3, 2, 1), xs.sorted(by: >))
    XCTAssertEqual([1, 2, 3], Array(xs))

    XCTAssertEqual(NonEmptyArray(1, 2, 3, 1, 2, 3), xs + xs)

    XCTAssertThrowsError(try NonEmptyArray(from: []))
  }

  func testBidirectionalCollection() {
    XCTAssertEqual(4, NonEmptyArray(1, 2, 3).last + 1)
    XCTAssertEqual(4, NonEmptyArray(3).last + 1)
  }

  func testMutableCollection() {
    var xs = NonEmptyArray(1, 2, 3)
    xs[0] = 42
    xs[1] = 43
    XCTAssertEqual(42, xs[0])
    XCTAssertEqual(43, xs[1])
  }

  func testRangeSubscript() {
    let xs = NonEmptyArray(1, 2, 3, 4)
    XCTAssertEqual([2, 3], xs[1...2])
  }

  func testRangeReplaceableCollection() {
    var xs = NonEmptyArray(1, 2, 3)

    XCTAssertEqual(xs, NonEmptyArray([1, 2, 3]))

    xs.append(4)
    XCTAssertEqual(NonEmptyArray(1, 2, 3, 4), xs)
    xs.append(contentsOf: [5, 6])
    XCTAssertEqual(NonEmptyArray(1, 2, 3, 4, 5, 6), xs)
    xs.insert(0, at: 0)
    XCTAssertEqual(NonEmptyArray(0, 1, 2, 3, 4, 5, 6), xs)
    xs.insert(contentsOf: [-2, -1], at: 0)
    XCTAssertEqual(NonEmptyArray(-2, -1, 0, 1, 2, 3, 4, 5, 6), xs)
    xs.insert(contentsOf: [], at: 0)
    XCTAssertEqual(NonEmptyArray(-2, -1, 0, 1, 2, 3, 4, 5, 6), xs)
    xs.insert(7, at: 9)
    XCTAssertEqual(NonEmptyArray(-2, -1, 0, 1, 2, 3, 4, 5, 6, 7), xs)
    xs.insert(contentsOf: [8, 9], at: 10)
    XCTAssertEqual(NonEmptyArray(-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9), xs)
    xs += [10]
    XCTAssertEqual(NonEmptyArray(-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10), xs)
    XCTAssertEqual(NonEmptyArray(-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11), xs + [11])
  }

  func testSetAlgebra() {
    XCTAssertEqual(3, NonEmptySet(1, 1, 2, 3).count)

    XCTAssertTrue(NonEmptySet(1, 2, 3).contains(1))
    XCTAssertTrue(NonEmptySet(1, 2, 3).contains(3))
    XCTAssertFalse(NonEmptySet(1, 2, 3).contains(4))

    XCTAssertEqual(NonEmptySet(1, 2, 3, 4, 5, 6), NonEmptySet(1, 2, 3).union(NonEmptySet(4, 5, 6)))
    XCTAssertEqual(NonEmptySet(1, 2, 3, 4, 5, 6), NonEmptySet(1, 2, 3).union([4, 5, 6]))
    XCTAssertEqual([3], NonEmptySet(1, 2, 3).intersection(NonEmptySet(3, 4, 5)))
    XCTAssertEqual([3], NonEmptySet(1, 2, 3).intersection([3, 4, 5]))
    XCTAssertEqual([1, 2, 4, 5], NonEmptySet(1, 2, 3).symmetricDifference(NonEmptySet(3, 4, 5)))
    XCTAssertEqual([1, 2, 4, 5], NonEmptySet(1, 2, 3).symmetricDifference([3, 4, 5]))

    var xs = NonEmptySet(1, 2, 3)

    XCTAssertEqual(xs, NonEmptySet([1, 2, 3]))

    var (inserted, memberAfterInsert) = xs.insert(1)
    XCTAssertFalse(inserted)
    XCTAssertEqual(1, memberAfterInsert)
    XCTAssertEqual(3, xs.count)
    (inserted, memberAfterInsert) = xs.insert(4)
    XCTAssertTrue(inserted)
    XCTAssertEqual(4, memberAfterInsert)
    XCTAssertEqual(4, xs.count)
    xs.formUnion(NonEmptySet(5, 6))
    XCTAssertEqual(NonEmptySet(1, 2, 3, 4, 5, 6), xs)
    xs.formUnion([7, 8])
    XCTAssertEqual(NonEmptySet(1, 2, 3, 4, 5, 6, 7, 8), xs)

    XCTAssertEqual([2, 3], NonEmptySet(1, 2, 3).subtracting(NonEmptySet(1)))
    XCTAssertEqual([1, 2], NonEmptySet(1, 2, 3).subtracting(NonEmptySet(3)))
    XCTAssertEqual([2, 3], NonEmptySet(1, 2, 3).subtracting([1]))
    XCTAssertEqual([1, 2], NonEmptySet(1, 2, 3).subtracting([3]))

    XCTAssertTrue(NonEmptySet(1, 2, 3).isSubset(of: NonEmptySet(1, 2, 3)))
    XCTAssertTrue(NonEmptySet(1, 2, 3).isSubset(of: [1, 2, 3]))
    XCTAssertTrue(NonEmptySet(1, 2, 3).isStrictSubset(of: NonEmptySet(1, 2, 3, 4)))
    XCTAssertTrue(NonEmptySet(1, 2, 3).isStrictSubset(of: [1, 2, 3, 4]))
    XCTAssertFalse(NonEmptySet(1, 2, 3).isStrictSubset(of: NonEmptySet(1, 2, 3)))
    XCTAssertFalse(NonEmptySet(1, 2, 3).isStrictSubset(of: [1, 2, 3]))
    XCTAssertTrue(NonEmptySet(1, 2, 3).isSuperset(of: NonEmptySet(1, 2, 3)))
    XCTAssertTrue(NonEmptySet(1, 2, 3).isSuperset(of: [1, 2, 3]))
    XCTAssertTrue(NonEmptySet(1, 2, 3, 4).isStrictSuperset(of: NonEmptySet(1, 2, 3)))
    XCTAssertTrue(NonEmptySet(1, 2, 3, 4).isStrictSuperset(of: [1, 2, 3]))
    XCTAssertFalse(NonEmptySet(1, 2, 3).isStrictSuperset(of: NonEmptySet(1, 2, 3)))
    XCTAssertFalse(NonEmptySet(1, 2, 3).isStrictSuperset(of: [1, 2, 3]))
    XCTAssertTrue(NonEmptySet(1, 2, 3).isDisjoint(with: NonEmptySet(4, 5, 6)))
    XCTAssertTrue(NonEmptySet(1, 2, 3).isDisjoint(with: [4, 5, 6]))
    XCTAssertFalse(NonEmptySet(1, 2, 3).isDisjoint(with: NonEmptySet(3, 4, 5)))
    XCTAssertFalse(NonEmptySet(1, 2, 3).isDisjoint(with: [3, 4, 5]))
  }

  func testDictionary() {
    let nonEmptyDict1 = NonEmpty(("1", "Blob"), ["1": "Blobbo"], uniquingKeysWith: { $1 })
    XCTAssertEqual(1, nonEmptyDict1.count)
    XCTAssertEqual("Blobbo", nonEmptyDict1["1"])
    XCTAssertEqual(
      "Blob", NonEmpty(("1", "Blob"), ["1": "Blobbo"], uniquingKeysWith: { v, _ in v })["1"])

    let nonEmptySingleton1 = NonEmptyDictionary((key: "1", value: "Blob"))
    XCTAssertEqual(1, nonEmptySingleton1.count)

    XCTAssert(
      NonEmpty<[String: String]>(("1", "Blob"), ["2": "Blob Senior"])
        .merging(["2": "Blob Junior"], uniquingKeysWith: { $1 })
        == NonEmpty(("1", "Blob"), ["2": "Blob Junior"])
    )
    XCTAssert(
      NonEmpty<[String: String]>(("1", "Blob"), ["2": "Blob Senior"])
        .merging(["2": "Blob Junior"], uniquingKeysWith: { a, _ in a })
        == NonEmpty(("1", "Blob"), ["2": "Blob Senior"])
    )
  }

  func testEquatable() {
    XCTAssertEqual(NonEmptyArray(1, 2, 3), NonEmptyArray(1, 2, 3))
    XCTAssertNotEqual(NonEmptyArray(1, 2, 3), NonEmptyArray(2, 2, 3))
    XCTAssertNotEqual(NonEmptyArray(1, 2, 3), NonEmptyArray(1, 2, 4))
    XCTAssertEqual(NonEmptySet(1, 2, 3), NonEmptySet(3, 2, 1))
    XCTAssert(
      NonEmpty(("hello", "world"), ["goodnight": "moon"])
        == NonEmpty(("goodnight", "moon"), ["hello": "world"])
    )
  }

  func testComparable() {
    XCTAssertEqual(2, NonEmptyArray(1, 2, 3).min() + 1)
    XCTAssertEqual(2, NonEmptyArray(3, 2, 1).min() + 1)
    XCTAssertEqual(2, NonEmptyArray(1).min() + 1)
    XCTAssertEqual(4, NonEmptyArray(1, 2, 3).max() + 1)
    XCTAssertEqual(4, NonEmptyArray(3, 2, 1).max() + 1)
    XCTAssertEqual(4, NonEmptyArray(3).max() + 1)
    XCTAssertEqual(NonEmptyArray(1, 2, 3), NonEmptyArray(3, 1, 2).sorted())
    XCTAssertEqual(NonEmptyArray(1), NonEmptyArray(1).sorted())
  }

  func testCodable() throws {
    let xs = NonEmptyArray(1, 2, 3)
    XCTAssertEqual(
      xs, try JSONDecoder().decode(NonEmptyArray<Int>.self, from: JSONEncoder().encode(xs)))
    XCTAssertEqual(
      xs, try JSONDecoder().decode(NonEmptyArray<Int>.self, from: Data("[1,2,3]".utf8)))
    XCTAssertThrowsError(try JSONDecoder().decode(NonEmptyArray<Int>.self, from: Data("[]".utf8)))

    let str = NonEmptyString(rawValue: "Hello")!
    XCTAssertEqual(
      [str], try JSONDecoder().decode([NonEmptyString].self, from: JSONEncoder().encode([str])))
    XCTAssertEqual(
      [str], try JSONDecoder().decode([NonEmptyString].self, from: Data(#"["Hello"]"#.utf8)))
    XCTAssertThrowsError(try JSONDecoder().decode([NonEmptyString].self, from: Data(#"[""]"#.utf8)))

    let dict = NonEmpty(rawValue: ["Hello": 1])!
    XCTAssertEqual(
      dict, try JSONDecoder().decode(NonEmpty<[String: Int]>.self, from: JSONEncoder().encode(dict))
    )
    XCTAssertEqual(
      dict, try JSONDecoder().decode(NonEmpty<[String: Int]>.self, from: Data(#"{"Hello":1}"#.utf8))
    )
    XCTAssertThrowsError(
      try JSONDecoder().decode(NonEmpty<[String: Int]>.self, from: Data("{}".utf8)))
  }

  func testNonEmptySetWithTrivialValue() {
    let xs = NonEmptySet<TrivialHashable>(.init(value: 1), .init(value: 2))
    let ys = NonEmptySet<TrivialHashable>(.init(value: 2), .init(value: 1))

    XCTAssertEqual(xs, ys)
  }

  func testMutableCollectionWithArraySlice() {
    let numbers = Array(1...10)
    var xs = NonEmpty(rawValue: numbers[5...])!
    xs[6] = 43
    XCTAssertEqual(43, xs[6])
  }

  #if canImport(SwiftUI)
    func testMove() {
      var xs: NonEmptyArray<String> = .init("A", "B", "C")
      xs.move(fromOffsets: [1], toOffset: 3)
      XCTAssertEqual(.init("A", "C", "B"), xs)
    }
  #endif

  func testNestedNonEmpty() throws {
    // Test type safe accessors
    let digits = Array(1...10)
    try XCTAssertEqual(AtLeast1(digits).first,   1)
    try XCTAssertEqual(AtLeast2(digits).second,  2)
    try XCTAssertEqual(AtLeast3(digits).third,   3)
    try XCTAssertEqual(AtLeast4(digits).fourth,  4)
    try XCTAssertEqual(AtLeast5(digits).fifth,   5)
    try XCTAssertEqual(AtLeast6(digits).sixth,   6)
    try XCTAssertEqual(AtLeast7(digits).seventh, 7)
    try XCTAssertEqual(AtLeast8(digits).eighth,  8)
    try XCTAssertEqual(AtLeast9(digits).ninth,   9)
    try XCTAssertEqual(AtLeast10(digits).tenth, 10)

    // Test type safe accessors on more nested types
    let atLeast10Digits = try AtLeast10(digits)
    XCTAssertEqual(atLeast10Digits.first,   1)
    XCTAssertEqual(atLeast10Digits.second,  2)
    XCTAssertEqual(atLeast10Digits.third,   3)
    XCTAssertEqual(atLeast10Digits.fourth,  4)
    XCTAssertEqual(atLeast10Digits.fifth,   5)
    XCTAssertEqual(atLeast10Digits.sixth,   6)
    XCTAssertEqual(atLeast10Digits.seventh, 7)
    XCTAssertEqual(atLeast10Digits.eighth,  8)
    XCTAssertEqual(atLeast10Digits.ninth,   9)
    XCTAssertEqual(atLeast10Digits.tenth,  10)

    // Test `minimumCount`
    XCTAssertEqual(         NonEmpty<[Int]> .minimumCount, 1)
    XCTAssertEqual(         AtLeast2<[Int]> .minimumCount, 2)
    XCTAssertEqual(AtLeast2<AtLeast2<[Int]>>.minimumCount, 4)

    // Test count and access by index
    let exactly21Numbers = try AtLeast8(AtLeast8(Array(0...20)))
    XCTAssertEqual(exactly21Numbers.count, 21)
    XCTAssertEqual(exactly21Numbers[12], 12)

    // Test initializers correctly throw
    XCTAssertThrowsError(try AtLeast2(digits.prefix(1)))
    XCTAssertThrowsError(try AtLeast3(digits.prefix(2)))
    XCTAssertThrowsError(try AtLeast4(digits.prefix(3)))
    XCTAssertThrowsError(try AtLeast5(digits.prefix(4)))
    XCTAssertThrowsError(try AtLeast6(digits.prefix(5)))
    XCTAssertThrowsError(try AtLeast7(digits.prefix(6)))
    XCTAssertThrowsError(try AtLeast8(digits.prefix(7)))
    XCTAssertThrowsError(try AtLeast9(digits.prefix(8)))
    XCTAssertThrowsError(try AtLeast10(digits.prefix(9)))
    XCTAssertThrowsError(try AtLeast10(AtLeast10(Array(1...19))))
    XCTAssertThrowsError(try NonEmpty(NonEmpty([1])))
    XCTAssertThrowsError(try AtLeast2(AtLeast2([1, 2, 3])))

    // Test initializers correctly **not** throw
    XCTAssertNoThrow(try AtLeast8(AtLeast8(Array(1...16))))

    // Test nested `NonEmpty` can be initialized in a safe way
    XCTAssertEqual(NonEmpty        (1, tail: [2, 3]).first, 1)
    XCTAssertEqual(NonEmpty<[Int]> (1, 2, 3)        .first, 1)
    XCTAssertEqual(NonEmpty<[Int]> (1)              .first, 1)
    XCTAssertEqual(AtLeast1        (1, tail: [2, 3]).first, 1)
    XCTAssertEqual(AtLeast1<[Int]> (1, 2, 3)        .first, 1)
    XCTAssertEqual(AtLeast1<[Int]> (1)              .first, 1)
    XCTAssertEqual(AtLeast2        (1, 2, tail: [3, 4]).second, 2)
    XCTAssertEqual(AtLeast2<[Int]> (1, 2, 3, 4)        .second, 2)
    XCTAssertEqual(AtLeast2<[Int]> (1, 2)              .second, 2)
    XCTAssertEqual(AtLeast3        (1, 2, 3, tail: [4, 5]).third, 3)
    XCTAssertEqual(AtLeast3<[Int]> (1, 2, 3, 4, 5)        .third, 3)
    XCTAssertEqual(AtLeast3<[Int]> (1, 2, 3)              .third, 3)
    XCTAssertEqual(AtLeast4        (1, 2, 3, 4, tail: [5, 6]).fourth, 4)
    XCTAssertEqual(AtLeast4<[Int]> (1, 2, 3, 4, 5, 6)        .fourth, 4)
    XCTAssertEqual(AtLeast4<[Int]> (1, 2, 3, 4)              .fourth, 4)
    XCTAssertEqual(AtLeast5        (1, 2, 3, 4, 5, tail: [6, 7]).fifth, 5)
    XCTAssertEqual(AtLeast5<[Int]> (1, 2, 3, 4, 5, 6, 7)        .fifth, 5)
    XCTAssertEqual(AtLeast5<[Int]> (1, 2, 3, 4, 5)              .fifth, 5)
    XCTAssertEqual(AtLeast6        (1, 2, 3, 4, 5, 6, tail: [7, 8]).sixth, 6)
    XCTAssertEqual(AtLeast6<[Int]> (1, 2, 3, 4, 5, 6, 7, 8)        .sixth, 6)
    XCTAssertEqual(AtLeast6<[Int]> (1, 2, 3, 4, 5, 6)              .sixth, 6)
    XCTAssertEqual(AtLeast7        (1, 2, 3, 4, 5, 6, 7, tail: [8, 9]).seventh, 7)
    XCTAssertEqual(AtLeast7<[Int]> (1, 2, 3, 4, 5, 6, 7, 8, 9)        .seventh, 7)
    XCTAssertEqual(AtLeast7<[Int]> (1, 2, 3, 4, 5, 6, 7)              .seventh, 7)
    XCTAssertEqual(AtLeast8        (1, 2, 3, 4, 5, 6, 7, 8, tail: [9, 10]).eighth, 8)
    XCTAssertEqual(AtLeast8<[Int]> (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)        .eighth, 8)
    XCTAssertEqual(AtLeast8<[Int]> (1, 2, 3, 4, 5, 6, 7, 8)               .eighth, 8)
    XCTAssertEqual(AtLeast9        (1, 2, 3, 4, 5, 6, 7, 8, 9, tail: [10, 11]).ninth, 9)
    XCTAssertEqual(AtLeast9<[Int]> (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)        .ninth, 9)
    XCTAssertEqual(AtLeast9<[Int]> (1, 2, 3, 4, 5, 6, 7, 8, 9)                .ninth, 9)
    XCTAssertEqual(AtLeast10       (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, tail: [11, 12]).tenth, 10)
    XCTAssertEqual(AtLeast10<[Int]>(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)        .tenth, 10)
    XCTAssertEqual(AtLeast10<[Int]>(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)                .tenth, 10)

    // Test that appending to a nested `NonEmpty` works as expected
    var mutableDigits = AtLeast2<[Int]>(1, 2)
    XCTAssertEqual(Array(mutableDigits), [1, 2])
    XCTAssertEqual(mutableDigits.first, 1)
    XCTAssertEqual(mutableDigits.last, 2)
    mutableDigits.append(3)
    XCTAssertEqual(Array(mutableDigits), [1, 2, 3])
    XCTAssertEqual(mutableDigits.first, 1)
    XCTAssertEqual(mutableDigits.last, 3)

    // Test some code does not compile
    // Note: I couldn't find a way to assert this, so one way to check it is to uncomment the code
//    _ = try AtLeast1(digits).second
//    _ = try AtLeast2(digits).third
//    _ = try AtLeast3(digits).fourth
//    _ = try AtLeast4(digits).fifth
//    _ = try AtLeast5(digits).sixth
//    _ = try AtLeast6(digits).seventh
//    _ = try AtLeast7(digits).eighth
//    _ = try AtLeast8(digits).ninth
//    _ = try AtLeast9(digits).tenth
  }
}

struct TrivialHashable: Equatable, Comparable, Hashable {
  let value: Int
  static func < (lhs: TrivialHashable, rhs: TrivialHashable) -> Bool {
    return lhs.value < rhs.value
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.value)
  }
}
