xcodeproj:
	PF_DEVELOP=1 swift run xcodegen

linux-main:
	swift test --generate-linuxmain

test-linux:
	docker run \
 		--rm \
 		-v "$(PWD):$(PWD)" \
 		-w "$(PWD)" \
 		swift:5.1 \
 		bash -c 'make test-swift'

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
	swift test \
 		--enable-pubgrub-resolver \
 		--enable-test-discovery \
 		--parallel

test-all: test-linux test-macos test-ios test-swift
