default: test-all

xcodeproj:
	PF_DEVELOP=1 swift run xcodegen

test-all: test-linux test-swift

test-linux:
	docker run \
 		--rm \
 		-v "$(PWD):$(PWD)" \
 		-w "$(PWD)" \
		swift:5.2 \
 		bash -c 'make test-swift'

test-swift:
	swift test \
 		--enable-pubgrub-resolver \
 		--enable-test-discovery \
 		--parallel

format:
	swift format --in-place --recursive ./Package.swift ./Sources ./Tests

.PHONY: format test-all test-swift test-workspace
