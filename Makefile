xcodeproj:
	PF_DEVELOP=1 swift run xcodegen

linux-main:
	swift test --generate-linuxmain

test-linux:
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
		-destination platform="iOS Simulator,name=iPhone Xʀ,OS=12.2" \
		| xcpretty

test-swift:
	swift test --parallel -v

test-all: test-linux test-mac test-ios
