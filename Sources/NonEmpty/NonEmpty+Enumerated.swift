import Foundation

extension NonEmpty {
  public func enumerated() -> Enumerated<Collection> {
    Enumerated(self)
  }
}

extension NonEmpty {
  public struct Enumerated<Collection: Swift.Collection> {
    private let rawValue: Collection
    
    init(_ nonEmpty: NonEmpty<Collection>) {
      rawValue = nonEmpty.rawValue
    }
    
    public var first: Iterator.Element {
      var iterator = makeIterator()
      return iterator.next()!
    }
    
    public func map<T>(_ transform: (Iterator.Element) throws -> T) rethrows -> NonEmpty<[T]> {
      NonEmpty<[T]>(rawValue: try makeIterator().map(transform))!
    }
    
    public func flatMap<SegmentOfResult>(
      _ transform: (Iterator.Element) throws -> NonEmpty<SegmentOfResult>
    ) rethrows -> NonEmpty<[SegmentOfResult.Element]> where SegmentOfResult: Sequence {
      NonEmpty<[SegmentOfResult.Element]>(rawValue: try makeIterator().flatMap(transform))!
    }
    
    public func shuffled<T>(using generator: inout T) -> NonEmpty<[Iterator.Element]>
    where T: RandomNumberGenerator {
      NonEmpty<[Iterator.Element]>(rawValue: makeIterator().shuffled(using: &generator))!
    }
    
    public func shuffled() -> NonEmpty<[Iterator.Element]> {
      NonEmpty<[Iterator.Element]>(rawValue: makeIterator().shuffled())!
    }
  }
}

extension NonEmpty.Enumerated: Sequence {
  public typealias Iterator = EnumeratedSequence<Collection>.Iterator
  
  public func makeIterator() -> Iterator {
    rawValue.enumerated().makeIterator()
  }
}
