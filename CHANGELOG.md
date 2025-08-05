# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-08-04

### Added

- Initial release of Flux Java implementation
- Core `ByteStream` class for byte stream processing
- Comprehensive error handling with `Buzz` exception hierarchy:
  - `BuzzEmptyPayload` for empty stream operations
  - `BuzzStreamOverflow` for out-of-bounds access beyond end
  - `BuzzStreamUnderflow` for out-of-bounds access before start
- Command-line interface (CLI) with:
  - Byte inspection capabilities
  - Version information (`-v`, `--version`)
  - Detailed error reporting with emojis
- Build automation with Makefile:
  - Library and CLI compilation
  - Test execution with JUnit Platform
  - Code coverage reporting with JaCoCo
  - Code formatting with Google Java Format
  - JAR packaging for distribution
- Comprehensive test suite with performance testing
- Documentation with usage examples
- Apache License 2.0

### Features

- Safe byte access with bounds checking
- Immutable byte stream design
- Zero-copy byte array wrapping
- Detailed error messages with context
- Cross-platform CLI tool
- Full test coverage reporting

### Build & Development

- Java 8+ compatibility
- Make-based build system
- Automated dependency downloads
- File watching for continuous testing
- Code formatting enforcement
- Coverage reporting with HTML output

[1.0.0]: https://github.com/x96-sys/flux.java/releases/tag/v1.0.0
