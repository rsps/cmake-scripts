---
title: Test Case
description: How to define a test case
keywords: testing, test-case, cmake
author: RSP Systems A/S
---

# Test Case

`define_test_case()` is used to describe a [test-case](https://en.wikipedia.org/wiki/Test_case). In this context,
a test case can be interpreted as a collection or related tests.

[TOC]

## Parameters

The following parameters are accepted:

* < name >:  _Human readable name of test case. The parameter is also used as an affix for test names, in ctest._
* `BEFORE`: (_optional_), _Command or macro to execute before each test in test-case (see [Before / After Callbacks](#before-after-callbacks))._
* `AFTER`: (_optional_), _Command or macro to execute after each test in test-case (see [Before / After Callbacks](#before-after-callbacks))._
* `LABELS`: (_optional_), _List of labels to associate subsequent tests with (see [labels](#labels))._
* `RUN_SERIAL`: (_optional_), _Option that prevents test-case's tests from running in parallel with other tests._

!!! warning "Rebuild Required"
    Changes to function `define_test_case()` parameters requires you to rebuild your project, before the changes take effect.

## Example

```cmake
# ...inside your test file...
include("rsp/testing")

define_test_case(
    "Assets Test"
    LABELS "assets"
)

# ...tests not shown ...
```

Once you have defined a test-case, in the beginning of your test file, then all subsequent [test definitions](./03_test.md)
will automatically be associated with that test-case.

!!! warning "Caution"
    You should avoid defining multiple test-cases in a single file, as it can lead to unexpected behaviour.
    _See [multiple test-cases in same file](#multiple-test-cases-in-same-file) for details._
    

## Labels

The `LABELS` parameter allows you to specify a list of labels, which are then automatically associated with each test,
in the test-case. This also enables you to use [ctest's label regex](https://cmake.org/cmake/help/latest/manual/ctest.1.html#cmdoption-ctest-L)
functionality to limit the tests that you wish to run (_see ctest run example in [test-suite documentation](./01_test_suite.md#labels)_).

```cmake
define_test_case(
    "Assets Test"
    LABELS "assets;resources;build"
)

# ...tests not shown ...
```

## Before / After Callbacks

The `BEFORE` and `AFTER` parameters allow you to specify a function or macro that must be executed before or after
each test. This can be useful in situations when your tests require setup and teardown logic.

```cmake
define_test_case(
    "Assets Test"

    BEFORE "before_assets_test"
    AFTER "after_assets_test"
)

macro(before_assets_test)
    # ...your setup logic...
    set(OUTPUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/output" PARENT_SCOPE)
    
    # ...etc
endmacro()

function(after_assets_test)
    # ... cleanup not shown ...
endfunction()

# "Before" macro will be invoked before the test...  
define_test("can build assets" "can_build_assets")
function(can_build_assets)
    # ... not shown ...
endfunction()

# "After" function will be invoked after the above test...
```

!!! info "Tip"
    Depending on the complexity of your before and after logic, you have to set the [`RUN_SERIAL`](#run-serial),
    to avoid race-conditions when tests are executed in parallel.

## Run Serial

If you are executing tests in [parallel](https://cmake.org/cmake/help/latest/manual/ctest.1.html#cmdoption-ctest-j),
and you have complex setup and teardown logic that could lead to
[race conditions](https://en.wikipedia.org/wiki/Race_condition#In_software), then you _SHOULD_ mark the test-case to
execute its tests in serial, by setting the `RUN_SERIAL` option.

```cmake
define_test_case(
    "Assets Test"

    BEFORE "before_assets_test"
    AFTER "after_assets_test"
    RUN_SERIAL
)

# ...remaining not shown...
```

## Multiple Test-Cases in same file

If you wish to define multiple test-cases in the same file, then you manually need to "end" each test-case, before
defining a new test-case.

```cmake
# ...inside your test file...
define_test_case(
    "Test-Case A"
)

# ...tests not shown ...

# End / Close "Test-Case A"
end_test_case()

define_test_case(
    "Test-Case B"
)

# ...tests not shown ...

# End / Close "Test-Case B"
end_test_case()
```

Normally, `define_test_suite()` automatically ensures to "end" test-cases. However, it presumes that each test file only
defines a single test-case.

_Please review the source code for additional information._ 