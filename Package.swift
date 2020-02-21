// swift-tools-version:5.1
import Foundation
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

if ProcessInfo.processInfo.environment.keys.contains("PF_DEVELOP") {
  package.dependencies.append(
    contentsOf: [
      .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.3.0"),
    ]
  )
}
