imports = \
	@testable import NonEmptyTests;

xcodeproj:
	xcodegen

linux-main:
	sourcery \
		--sources ./Tests/ \
		--templates ./.sourcery-templates/ \
		--output ./Tests/ \
		--args testimports='$(imports)' \
		&& mv ./Tests/LinuxMain.generated.swift ./Tests/LinuxMain.swift

test-linux: linux-main
	docker build --tag nonempty-testing . \
		&& docker run --rm nonempty-testing

test-macos:
	set -o pipefail && \
	xcodebuild test \
		-scheme NonEmpty_macOS \
		-destination platform="macOS" \
		| xcpretty

test-ios:
	set -o pipefail && \
	xcodebuild test \
		-scheme NonEmpty_iOS \
		-destination platform="iOS Simulator,name=iPhone XR,OS=12.1" \
		| xcpretty

test-swift:
	swift test

test-all: test-linux test-mac test-ios
