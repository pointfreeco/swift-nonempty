//extension NonEmpty {
//  public func joined<S: Sequence, RRC: RangeReplaceableCollection>(
//    separator: S
//  )
//    -> NonEmpty<RRC>
//    where Element == NonEmpty<RRC>, S.Element == RRC.Element {
//
//      return NonEmpty<RRC>(
//        self.head.head, self.head.tail + RRC(separator) + RRC(self.tail.joined(separator: separator))
//      )
//  }
//
//  public func joined<RRC: RangeReplaceableCollection>() -> NonEmpty<RRC> where Element == NonEmpty<RRC> {
//    return joined(separator: RRC())
//  }
//}
