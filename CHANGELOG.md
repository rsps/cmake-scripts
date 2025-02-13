# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-02-13

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

[Unreleased]: https://github.com/rsps/cmake-scripts/compare/0.1.0...HEAD
[0.1.0]: https://github.com/rsps/cmake-scripts/releases/tag/0.1.0