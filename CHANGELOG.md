# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

* Project's root `CMakeLists.txt`.
* `dependencies.cmake` and `dev-dependencies.cmake` scripts.
* `CPM.cmake` script that downloads specified version of [CPM](https://github.com/cpm-cmake/CPM.cmake).
* `dump()`, `dd()` and `fail_in_source_build()` utils functions, in `helpers.cmake`.
* `semver_parse()`, `write_version_file` and `version_from_file()` utils, in `version.cmake`.
* `git_find_version_tag()` util, in `git.cmake`.
* `VERSION` file.
* Caching utilities, `cache.cmake`.

[Unreleased]: https://github.com/rsps/cmake-scripts/compare/develop
