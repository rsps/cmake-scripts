---
title: Run Tests
description: How to run tests
keywords: testing, execution, cmake
author: RSP Systems A/S
---

# Run Tests

To run test tests, you must first ensure that you build your CMake project. Once you have done so, use the
[ctest executable](https://cmake.org/cmake/help/latest/manual/ctest.1.html) to execute the tests.

```sh
ctest --output-on-failure --test-dir <your-build-directory>/tests
```

## Run Specific Tests

To run only certain tests, use the `--label-regex` option.

```sh
ctest --output-on-failure \
  --label-regex "unit" \
  --test-dir <your-build-directory>/tests
```

For additional information, see "labels" section in [test suites](./01_test_suite.md#labels) and
[test cases](./02_test_case.md#labels).

## Run Parallel

To run tests in parallel, use the `--parallel` option.

```sh
ctest --output-on-failure --parallel --test-dir <your-build-directory>/tests
```

## Run Failed

To (re)run tests that have failed, use the `--rerun-failed` option.

```sh
ctest --rerun-failed --test-dir <your-build-directory>/tests
```

## Onward

For additional command line arguments and options, please review the official documentation for the
[ctest executable]().