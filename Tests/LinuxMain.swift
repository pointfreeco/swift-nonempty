// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import XCTest

@testable import NonEmptyTests;
extension NonEmptyTests {
  static var allTests: [(String, (NonEmptyTests) -> () throws -> Void)] = [
    ("testCollection", testCollection),
    ("testCollectionWithIntIndex", testCollectionWithIntIndex),
    ("testBidirectionalCollection", testBidirectionalCollection),
    ("testMutableCollection", testMutableCollection),
    ("testRangeReplaceableCollection", testRangeReplaceableCollection),
    ("testSetAlgebra", testSetAlgebra),
    ("testDictionary", testDictionary),
    ("testString", testString),
    ("testEquatable", testEquatable),
    ("testComparable", testComparable),
    ("testCodable", testCodable),
    ("testNonEmptySetWithTrivialValue", testNonEmptySetWithTrivialValue),
    ("testMutableCollectionWithArraySlice", testMutableCollectionWithArraySlice)
  ]
}

// swiftlint:disable trailing_comma
XCTMain([
  testCase(NonEmptyTests.allTests),
])
// swiftlint:enable trailing_comma
