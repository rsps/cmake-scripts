---
title: Test
description: How to define a test
keywords: testing, test, cmake
author: RSP Systems A/S
---

# Test

The `define_test()` function is used to describe what callback (_function_) must be invoked when tests are executed.
Behind the scene, this function is responsible to
[register](https://cmake.org/cmake/help/latest/command/add_test.html#command:add_test) the test for ctest.
This is done by adding a ctest that invokes an "intermediary" - a [test executor](./05_executor.md) - which is
responsible for invoking the specified callback, via `define_test()`. 

[TOC]

## Parameters

* < name >:  _Human readable name of test case._
* < callback >:  _The function that contains the actual test logic._
* `DATA_PROVIDER`: (_optional_), _Command or macro that provides data-set(s) for the test. See [data providers](#data-providers) for details._
* `EXPECT_FAILURE`: (_optional_), _Options, if specified then callback is expected to fail. See [failure expectations](#failure-expectations) for details._
* `SKIP`: (_optional_), _Option, if set then test will be marked as "disabled" and not executed. See [skipping tests](#skipping-tests) for details._

!!! warning "Rebuild Required"
    Changes to function `define_test()` parameters requires you to rebuild your project, before the changes take effect.

!!! danger "Caution"
    Although the `< callback >` parameter can accept a
    [marco](https://cmake.org/cmake/help/latest/command/macro.html#macro), you _SHOULD_ always use a
    [function](https://cmake.org/cmake/help/latest/command/function.html#command:function) for defining the actual
    test logic. Using a marco can lead to undesired side effects. Please read CMake's
    ["Macro vs. Function"](https://cmake.org/cmake/help/latest/command/macro.html#macro-vs-function) for additional
    details.

## Example

```cmake
include("rsp/testing")

# ... previous not shown ...

define_test("assets are ready after build" "asserts_ready")
function(asserts_ready)
    
    # ...actual test logic not shown here...
    
    assert_truthy(assets_exist MESSAGE "Assets have not been built...")
endfunction()
```

## Failure Expectations

When you need to test logic that is intended to fail when certain conditions are true, then you can mark your test
to expect a failure. This is done by setting the `EXPECT_FAILURE` option.

```cmake
define_test("fails when assets not built" "fails_when_not_ready" EXPECT_FAILURE)
function(fails_when_not_ready)

    # ...actual test logic not shown here...
    
    assert_truthy(false)
endfunction()
```

Behind the scene, ctest's [`WILL_FAIL`](https://cmake.org/cmake/help/latest/prop_test/WILL_FAIL.html#prop_test:WILL_FAIL)
property is set for the given test, when the `EXPECT_FAILURE` option is set.

## Data Providers

You can specify a function or marco as a test's data-provider, via the `DATA_PROVIDER` parameter.
Doing so will result in the same test being executed multiple times, with different sets of data.
The specified function or marco **MUST** assign a list of "items" (_test data_) to the given `< output >` variable.

```cmake
function(provides_data output)
    set("${output}" "a;b;c;d")
    return (PROPAGATE "${output}")
endfunction()

define_test(
    "My Test"
    "my_test"
    DATA_PROVIDER "provides_data"
)
function(my_test letter)
    string(LENGTH "${letter}" length)

    assert_greater_than(0 length MESSAGE "No letter provided: (length: ${length})")
endfunction()
```

In the above "My Test" will be registered multiple times, one for each item provided by the `provides_data()` function.
Each data-set item is then passed on to the test, as an argument.

!!! warning "Rebuild Required"
    Whenever you change the items provided by a "data provider" function, you will be required to rebuild
    your CMake project, before the changes are reflected by the executed tests!

## Skipping tests

Set the `SKIP` option, if you wish to ensure that a test is not executed by ctest.

```cmake
# Test is SKIPPED
define_test("can build with bitmap pictures" "can_build_with_bitmap" SKIP)
function(can_build_with_bitmap)

    # ...not shown...
    
endfunction()
```

Behind the scene, ctest's [`DISABLED`](https://cmake.org/cmake/help/latest/prop_test/DISABLED.html)
property is set, when a test is marked as skipped.