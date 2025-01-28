---
title: Test Suite
description: How to define a test suite
keywords: testing, test-suite, cmake
author: RSP Systems A/S
---

# Test Suite

The `define_test_suite()` function is used to group related test cases into a
[test suite](https://en.wikipedia.org/wiki/Test_suite). It accepts the following parameters:

* < name >:  _Human readable name of test suite. The parameter is also used to label tests (see [labels](#labels))._
* `DIRECTORY`: _Path to directory that contains test-cases._
* `MATCH`: (_optional_), _Glob pattern used to match test-case files. Defaults to `*_test.cmake` (see [match pattern](#match-pattern))._

!!! warning "Rebuild Required"
    Changes to function `define_test_suite()` parameters requires you to rebuild your project, before the changes take effect.

## Example

```cmake
include("rsp/testing")

define_test_suite("unit" DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/unit")
define_test_suite("integration" DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/integration")
```

Given the above shown example, when `define_test_suite()` is invoked, it will recursively search for files¹ in the
specified directory. Each file is then [included](https://cmake.org/cmake/help/latest/command/include.html) into the
current CMake scope. This means that calls to [`define_test_case()`](./02_test_case.md) and
[`define_test()`](./03_test.md) are registered (_tests are added to ctest_).

After you have built your CMake project, you will be able to run the tests. 

```sh
ctest --output-on-failure --test-dir <your-build-directory>/tests
```

¹: _See [match pattern](#match-pattern)._

## Match Pattern

By default, only files that match `*_test.cmake` will be processed by `define_test_suite()`. If this is not to your
liking, then you can specify a custom match pattern:

```cmake
define_test_suite(
    "unit"
    DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/unit"
    MATCH "*Test.cmake"
)
```

## Labels

The `< name >` parameter is used to automatically used as a [label](https://cmake.org/cmake/help/latest/prop_test/LABELS.html#prop_test:LABELS)
for all tests within the test suite. This allows you to use [ctest's label regex](https://cmake.org/cmake/help/latest/manual/ctest.1.html#cmdoption-ctest-L)
functionality and thereby only run the tests from the suite that you wish.

```sh
ctest --output-on-failure \
  --label-regex "integration" \
  --test-dir <your-build-directory>/tests
```