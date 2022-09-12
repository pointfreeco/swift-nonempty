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

  func testExpressibleByArrayLiteral() {
    let xs = NonEmpty<[Int]>(1, 2, 3)
    let ys: NonEmpty<[Int]> = [1, 2, 3]

    XCTAssertEqual(xs, ys)
    XCTAssertEqual(xs, [1, 2, 3])
    XCTAssertNotEqual(xs, [2, 1, 3])
  }

  func testExpressibleByDictionaryLiteral() {
    let xs = NonEmpty<[String: String]>(("a", "test"), ["b": "demo"])
    let ys: NonEmpty<[String: String]> = ["a": "test", "b": "demo"]

    XCTAssertEqual(xs, ys)
    XCTAssertEqual(xs, ["b": "demo", "a": "test"])
    XCTAssertEqual(xs.rawValue, ["b": "demo", "a": "test"])
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

    let data = NonEmpty(rawValue: Data("Hello".utf8))
    XCTAssertEqual(
      data, try JSONDecoder().decode(NonEmpty<Data>.self, from: JSONEncoder().encode(data)))
    XCTAssertEqual(
      data, try JSONDecoder().decode(NonEmpty<Data>.self, from: Data(#""SGVsbG8=""#.utf8)))
    XCTAssertThrowsError(try JSONDecoder().decode(NonEmpty<Data>.self, from: Data("\"\"".utf8)))
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
  
  func testEnumerated() {
    let actual = NonEmptyArray("1", "2", "3").enumerated()
    let expected = [(offset: 0, element: "1", (offset: 1, element: "2"), (offset: 2, element: "3"))]
    
    XCTAssertTrue(
      zip(actual, expected).allSatisfy {
        $0.offset == $1.offset && $0.element == $1.element
      }
    )
  }

  func testEnumeratedMap() {
    let xs = NonEmptyArray(1, 2, 3).enumerated()
    
    let nonEmptyArray: NonEmpty<[String]> = xs.map { String($0.element) }
    let array: [String] = xs.map { String($0.element) }
    
    XCTAssertEqual(nonEmptyArray, NonEmpty("1", "2", "3"))
    XCTAssertEqual(array, ["1", "2", "3"])
  }
  
  func testEnumeratedFlatMap() {
    let xs = NonEmptyArray(NonEmptyArray("1"), NonEmptyArray("2"), NonEmptyArray("3")).enumerated()
    
    let nonEmptyArray: NonEmpty<[String]> = xs.flatMap { $0.element }
    let array: [String] = xs.flatMap { $0.element }
    
    XCTAssertEqual(nonEmptyArray, NonEmpty("1", "2", "3"))
    XCTAssertEqual(array, ["1", "2", "3"])
  }
  
  func testEnumeratedFirst() {
    let xs = NonEmptyArray("Blob").enumerated()
    
    XCTAssertEqual(xs.first.offset, 0)
    XCTAssertEqual(xs.first.element, "Blob")
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
