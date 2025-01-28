# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

* Project's root `CMakeLists.txt`.
* `dependencies.cmake` and `dev-dependencies.cmake` scripts.
* `CPM.cmake` script that downloads specified version of [CPM](https://github.com/cpm-cmake/CPM.cmake).
* `dump()`, `dd()`, `fail_in_source_build()`, `extract_value()` and `safeguard_properties()` utils functions, in `helpers.cmake`.
* `semver_parse()`, `write_version_file` and `version_from_file()` utils, in `version.cmake`.
* `git_find_version_tag()` util, in `git.cmake`.
* `VERSION` file.
* Caching utilities, `cache.cmake`.
* A "mini" testing framework for cmake modules and scripts, in `testing.cmake`. 
* `RSP_CMAKE_SCRIPTS_BUILD_TESTS` project option for building tests.
* `tests.yaml` and `deploy-docs.yaml` GitHub Actions workflows.
* `composer.json` to install [Daux.io](https://daux.io) dev-dependency (_documentation generator_).
* "rsp" theme for Daux (_placed in `resources/daux/themes/rsp`_).
* Support Policy, Code of Conduct, Contribution Guide and Security Policy in the docs.
* Defect and Feature Request issue templates (_for GitHub_).
* Pull request template (_for GitHub_).

[Unreleased]: https://github.com/rsps/cmake-scripts/compare/develop
