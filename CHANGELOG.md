# jwlFusion Changelog

## Unreleased

### Added

### Changed

### Fixed

### Removed

____
## [v1.10.3] - 2025-08-28
### Added

- Set permissions on temp folder in macOS

## [v1.10.2] - 2025-08-28
### Changed

- Updated jwlCore libs to v0.16.0

## [v1.10.1] - 2025-08-28
### Changed

- Adjust version string
- Changed signature on jwlCore for macOS

## [v1.10.0] - 2025-08-26
## Changed

- Updated jwlCore libs to v0.15.0
  - adjusted ID for macOS libs

## [v1.9.0] - 2025-08-23
### Changed

- Updated jwlCore libs to v0.13.0
  - Compare Notes on GUID only

## [v1.8.0] - 2025-08-22
### Changed

- Updated jwlCore libs to v0.12.0

## [v1.7.0] - 2025-08-19
### Changed

- Updated jwlCore libs to v0.11.0

## [v1.6.0] - 2025-08-15
### Added

- Added more progress feedback

### Changed

- Updated jwlCore libs to v0.10.0
- Using faster zip compression

## [v1.5.0] - 2025-08-13
### Changed

- Updated jwlCore libs to v0.9.0
  - Improved Bookmark merge

## [v1.4.0] - 2025-07-30
### Changed

- Updated jwlCore libs to v0.8.0 (Android-ready)

## [v1.3.0] - 2025-07-27
### Added

- Added Windows ARM64 build (needs testing)

### Changed

- Use different result message passing
- Updated jwlCore libs to v0.6.0

## [v1.1.2] - 2025-07-23
### Changed

- Updated jwlCore libs to v0.3.0

## [v1.1.1] - 2025-07-23
### Changed

- Updated jwlCore libs to v0.2.1

### Fixed

- Deallocate error message string after echo

## [v1.1.0] - 2025-07-23
### Added

- Receive and output error messages from jwlCore
- Handle failed merge

### Changed
- Updated jwlCore libs to v0.2.0

## [v1.0.0] - 2025-03-28

- Stable release with jwlCore moved up to beta

## [v0.12.0] - 2025-03-20
### Added

- Show total time and CPU time

### Changed

- Updated jwlCore
  - Fixed merging Bookmarks

## [v0.11.0] - 2025-03-20

- Remove useless dependencies
- Include zip and unzip utilities in Windows package

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
[v1.10.3]:https://github.com/erykjj/jwlFusion/releases/tag/v1.10.3
[v1.10.2]:https://github.com/erykjj/jwlFusion/releases/tag/v1.10.2
[v1.10.1]:https://github.com/erykjj/jwlFusion/releases/tag/v1.10.1
[v1.10.0]:https://github.com/erykjj/jwlFusion/releases/tag/v1.10.0
[v1.9.0]:https://github.com/erykjj/jwlFusion/releases/tag/v1.9.0
[v1.8.0]:https://github.com/erykjj/jwlFusion/releases/tag/v1.8.0
[v1.7.0]:https://github.com/erykjj/jwlFusion/releases/tag/v1.7.0
[v1.6.0]:https://github.com/erykjj/jwlFusion/releases/tag/v1.6.0
[v1.5.0]:https://github.com/erykjj/jwlFusion/releases/tag/v1.5.0
[v1.4.0]:https://github.com/erykjj/jwlFusion/releases/tag/v1.4.0
[v1.3.0]:https://github.com/erykjj/jwlFusion/releases/tag/v1.3.0
[v1.1.2]:https://github.com/erykjj/jwlFusion/releases/tag/v1.1.2
[v1.1.1]:https://github.com/erykjj/jwlFusion/releases/tag/v1.1.1
[v1.1.0]:https://github.com/erykjj/jwlFusion/releases/tag/v1.1.0
[v1.0.0]:https://github.com/erykjj/jwlFusion/releases/tag/v1.0.0
[v0.12.0]:https://github.com/erykjj/jwlFusion/releases/tag/v0.12.0
[v0.11.0]:https://github.com/erykjj/jwlFusion/releases/tag/v0.11.0
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
