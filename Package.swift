// swift-tools-version:4.0

import PackageDescription

let package = Package(
  name: "NonEmpty",
  products: [
    .library(name: "NonEmpty", targets: ["NonEmpty"]),
    ],
  targets: [
    .target(name: "NonEmpty", dependencies: []),
    .testTarget(name: "NonEmptyTests", dependencies: ["NonEmpty"]),
    ]
)
