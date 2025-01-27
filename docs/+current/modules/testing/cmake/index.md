---
title: Modules & Scripts
description: How to write tests for your CMake modules and scripts
keywords: testing, cmake
author: RSP Systems A/S
---

# Testing CMake Modules & Scripts

The `testing` module includes a "_mini_" framework for testing your CMake modules and scripts. It is built on top of
[CTest](https://cmake.org/cmake/help/latest/manual/ctest.1.html#manual:ctest(1)).

[TOC]

## Getting Started

The following guide illustrates how you can get started. It is by no means a comprehensive guide on how to write tests,
but rather just a starting point.

### Directory Structure

Create an appropriate directory in which your tests should reside. For instance, this can be located in the root
of your project. You can name it "tests", or whatever makes the most sense for you. The important part is to isolate
tests from the remaining of your project's CMake logic.

The following example is a possible directory and files structure, that you can use.

```
/tests
    /unit
        /assets
            build_assets_test.cmake
    CMakeLists.txt    
CMakeLists.txt
```

### Define Test Suite

In your `/tests/CMakeLists.txt`, define the [test suite(s)](./01_test_suite.md) for your project.

```cmake
# ...in your /tests/CMakeLists.txt

enable_testing()

project(my_package_tests LANGUAGES NONE)

include("rsp/testing")

# Define the test suites for this project
define_test_suite("unit" DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/unit")
```

### Define Test Case

To define a new test case, invoke the [`define_test_case()`](./02_test_case.md) function.
This should be done in each test file (_e.g. in the `/tests/unit/assets/build_assets_tests.cmake` from the above
shown example directory and files structure)._

```cmake
# ... in your test file

include("rsp/testing")

define_test_case(
    "Build Assets Test"
    LABELS "assets;build"
)

# ... remaining not shown ...
```

### Define Test(s)

Once your test-case has been defined, you can define the tests. To do so, you need to define the function that must
be invoked when the test-case is executed. This is done by the [`define_test()`](./03_test.md) function.

```cmake
# ... in your test file

# ... previous not shown ...

define_test("can build assets" "can_build_assets")
function(can_build_assets)
    
    # ... testing logic not shown ...
    
    assert_truthy(assets_built MESSAGE "Assets could bot be built...")
endfunction()

define_test("fails if assets not ready" "fails_when_not_ready" EXPECT_FAILURE)
function(fails_when_not_ready)

    # ... testing logic not shown ...

    assert_truthy(false MESSAGE "Assets should not be built when not ready...")
endfunction()

# ... etc
```

### Build & Run

_TODO: ..._

## Caveats

_TODO: ..._