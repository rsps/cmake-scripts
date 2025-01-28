---
title: Executor
description: How to customise test executor
keywords: testing, execution, executor, cmake
author: RSP Systems A/S
---

# Test Executor

When tests are registered (_via [ctest's `add_test()`](https://cmake.org/cmake/help/latest/command/add_test.html)_),
a "test executor" (_cmake script_) is requested executed. The executor is then responsible for invoking the actual test
callback, that has been specified via [`define_test()`](./03_test.md#parameters).
In addition, the executor is also responsible for executing eventual
[before and after callbacks](./02_test_case.md#before-after-callbacks), for the test case.

## Location

The executor can be found at:
[`rsp/testing/executor.cmake`](https://github.com/rsps/cmake-scripts/blob/main/cmake/rsp/testing/executor.cmake).

## Custom Executor

To use a custom executor, set the path to your executor via the `RSP_TEST_EXECUTOR_PATH` property.
This _SHOULD_ be done before specifying your test suites.

```cmake
# ...in your /tests/CMakeLists.txt

enable_testing()

project(my_package_tests LANGUAGES NONE)

include("rsp/testing")

# Set path to custom test executor
set(RSP_TEST_EXECUTOR_PATH "../cmake/my_custom_test_executor.cmake")

define_test_suite("unit" DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/unit")
```
