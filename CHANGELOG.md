# jwlFusion Changelog

## Unreleased

### Added

### Changed

### Fixed

### Removed

____
## [v0.10.0] - 2025-03-18

- Use system zip and unzip

## [v0.9.0] - 2025-03-17

- Thank you, @Drizztfire & @benny-danny, for testing and reporting
- Set permissions on output archive
- Update jwlCore
  - Replace existing Bookmarks instead of skipping them
  - Update trim query

## [v0.8.3] - 2025-03-16

- Set default output directory to executable directory
- Re-enable some debugging output

## [v0.8.2] - 2025-03-16

- Hide temp directory
- Force remove temp directory on macOS and Linux

## [v0.8.1] - 2025-03-15

- Use os instead of osproc for system commands

## [v0.8.0] - 2025-03-15

- Implement own functions to resolve system modules not working on macOS
  - archive unzipping
  - create and remove directories

## [v0.7.0] - 2025-03-13

- Fixed double-compression
- Implemented own temporary directory procedure

## [v0.6.2] - 2025-03-13

- Replace joinPath procedure with simple concatenation

## [v0.6.1] - 2025-03-11

- Put jwlCore in same directory as executable (instead of lib/), as on Windows
- Various fixes with shared library loading for macOS and Linux
- Removed support for Windows on arm64 until a SQLite library can be obtained
- Add debug info output

## [v0.6.0] - 2025-03-05

- Rebuild jwlCore for other architectures

## [v0.5.2] - 2025-03-02

- Update jwlCore

## [v0.5.1] - 2025-02-25

- Update `jwlCore.dll`

## [v0.5.0] - 2025-02-25

- Initial release (beta)

____
[v0.10.0]:https://github.com/erykjj/jwlFusion/releases/tag/v0.10.0
[v0.9.0]:https://github.com/erykjj/jwlFusion/releases/tag/v0.9.0
[v0.8.3]:https://github.com/erykjj/jwlFusion/releases/tag/v0.8.3
[v0.8.2]:https://github.com/erykjj/jwlFusion/releases/tag/v0.8.2
[v0.8.1]:https://github.com/erykjj/jwlFusion/releases/tag/v0.8.1
[v0.8.0]:https://github.com/erykjj/jwlFusion/releases/tag/v0.8.0
[v0.7.0]:https://github.com/erykjj/jwlFusion/releases/tag/v0.7.0
[v0.6.2]:https://github.com/erykjj/jwlFusion/releases/tag/v0.6.2
[v0.6.1]:https://github.com/erykjj/jwlFusion/releases/tag/v0.6.1
[v0.6.0]:https://github.com/erykjj/jwlFusion/releases/tag/v0.6.0
[v0.5.2]:https://github.com/erykjj/jwlFusion/releases/tag/v0.5.2
[v0.5.1]:https://github.com/erykjj/jwlFusion/releases/tag/v0.5.1
[v0.5.0]:https://github.com/erykjj/jwlFusion/releases/tag/v0.5.0
