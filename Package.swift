// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "swift-nonempty",
  products: [
    .library(name: "NonEmpty", targets: ["NonEmpty"]),
  ],
  targets: [
    .target(name: "NonEmpty", dependencies: []),
    .testTarget(name: "NonEmptyTests", dependencies: ["NonEmpty"]),
  ]
)
