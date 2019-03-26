Pod::Spec.new do |s|
  s.name = "NonEmpty"
  s.version = "0.2.0"
  s.summary = "A compile-time guarantee that a collection contains a value."

  s.description = <<-DESC
  We often work with collections that should never be empty, but the type system makes no such guarantees, so we're forced to handle that empty case, often with if and guard statements. NonEmpty is a lightweight type that can transform any collection type into a non-empty version.
  DESC

  s.homepage = "https://github.com/pointfreeco/swift-nonempty"

  s.license = "MIT"

  s.authors = {
    "Stephen Celis" => "stephen@stephencelis.com",
    "Brandon Williams" => "mbw234@gmail.com"
  }
  s.social_media_url = "https://twitter.com/pointfreeco"

  s.source = {
    :git => "https://github.com/pointfreeco/swift-nonempty.git",
    :tag => s.version
  }

  s.swift_version = "5.0"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"

  s.source_files  = "Sources", "Sources/**/*.swift"
end
