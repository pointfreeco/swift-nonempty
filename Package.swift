// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "NonEmpty",
  products: [
    .library(name: "NonEmpty", targets: ["NonEmpty"]),
    ],
  dependencies: [
    .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.3.0"),
  ],
  targets: [
    .target(name: "NonEmpty", dependencies: []),
    .testTarget(name: "NonEmptyTests", dependencies: ["NonEmpty"]),
    ]
)
