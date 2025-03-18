# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added 

* `gcc_info()` function in `compilers/gcc.cmake`.

### Changed

* `gcc_version()` now uses `gcc_info()` to obtain GCC version.

### Fixed

* Internal property bleeds into global scope, when calling `gcc_version()`, due auto caching by `find_program()`. 

## [v0.2.0] - 2025-03-18

### Added

* `var_dump_all()` macro in `debug.cmake`.
* `gcc_version()` function in `compilers/gcc.cmake`.

### Changed

* Reformatted release (_version_) headings in `CHANGELOG.md`. 

### Fixed

* `CMAKE_MODULE_PATH` changes are not propagated to the top-most project, when "CMake Scripts" is included by other project as a nested dependency. 
* Release (_version_) links in `CHANGELOG.md`.

## [v0.1.0] - 2025-02-13

### Added

* Project's root `CMakeLists.txt`.
* `dependencies.cmake` and `dev-dependencies.cmake` scripts.
* `CPM.cmake` script that downloads specified version of [CPM](https://github.com/cpm-cmake/CPM.cmake).
* `fail_in_source_build()`, `extract_value()`, `requires_arguments()` and `safeguard_properties()` utils, in `helpers.cmake`.
* `dump()`, `dd()` and `var_dump()` in `debug.cmake`.
* ANSI utils, in `output.cmake`
* `semver_parse()`, `write_version_file` and `version_from_file()` utils, in `version.cmake`.
* `git_find_version_tag()` util, in `git.cmake`.
* `VERSION` file.
* RSP's GCC strict compile options, in `gcc.cmake` (_exposed via `compiler.cmake` module_).
* Caching utilities, `cache.cmake`.
* `output()` helper, in `output.cmake`.
* Support for ANSI, in `output.cmake`.
* PSR inspired logging functions, in `logging.cmake`.
* Utils for determining the datatype of a target variable or value, in `helpers.cmake`.
* A "mini" testing framework for cmake modules and scripts, in `testing.cmake`.
* `RSP_CMAKE_SCRIPTS_BUILD_TESTS` project option for building tests.
* `tests.yaml` and `deploy-docs.yaml` GitHub Actions workflows.
* `composer.json` to install [Daux.io](https://daux.io) dev-dependency (_documentation generator_).
* "rsp" theme for Daux (_placed in `resources/daux/themes/rsp`_).
* Support Policy, Code of Conduct, Contribution Guide and Security Policy in the docs.
* Defect and Feature Request issue templates (_for GitHub_).
* Pull request template (_for GitHub_).

[Unreleased]: https://github.com/rsps/cmake-scripts/compare/v0.2.0...HEAD
[v0.2.0]: https://github.com/rsps/cmake-scripts/compare/v0.1.0...v0.2.0
[v0.1.0]: https://github.com/rsps/cmake-scripts/releases/tag/v0.1.0