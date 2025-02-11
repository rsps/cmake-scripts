---
title: Types
description: How to use the helpers module.
keywords: helpers, cmake
author: RSP Systems A/S
---

# Type Utilities

The following helper functions can help you distinguish between the value type¹ of variables.

¹: _In CMake all variable values are strings. See [official documentation](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#variables) for details._

[TOC]

## `is_int`

Determines if value is an integer.

```cmake
is_int(22 a)
is_int("hi there" b)

message("${a}") # true
message("${b}") # false
```

## `is_float`

Determines if value is a float point.

```cmake
is_float(2.34 a)
is_float(2 b)
is_int("hi there" c)

message("${a}") # true
message("${b}") # false
message("${c}") # false
```

## `is_numeric`

Determines if value is numeric.

```cmake
is_numeric(22 a)
is_numeric(1.234 b)
is_numeric("hi there" c)

message("${a}") # true
message("${b}") # true
message("${c}") # false
```

## `is_bool`

Determines if value is a boolean (_`true` or `false`_).

```cmake
is_bool(true a)
is_bool(false b)
is_bool("on" c)

message("${a}") # true
message("${b}") # true
message("${c}") # false
```

## `is_bool_like`

Determine if value is a boolean like.
See CMake's official documentation for additional details:

* [constant](https://cmake.org/cmake/help/latest/command/if.html#constant)
* [logic operators](https://cmake.org/cmake/help/latest/command/if.html#logic-operators)


```cmake
is_bool_like(true a)
is_bool_like("yes" b)
is_bool_like(-2 c)

message("${a}") # true
message("${b}") # true
message("${c}") # false
```

## `is_list`

Determines if value is a list of values.
See CMake's official [documentation](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-lists)
for additional details.

```cmake
is_list("aa;bbb;ccc" a)

set(my_list "aa;bbb;ccc")
is_list(my_list b)

set(my_other_list aa bbb ccc)
is_list(my_other_list c)

is_list("aa bbb ccc" d)

message("${a}") # true
message("${b}") # true
message("${c}") # true
message("${d}") # false
```

## `is_command`

Determines if value is command, [macro](https://cmake.org/cmake/help/latest/command/macro.html#macro) or
[function](https://cmake.org/cmake/help/latest/command/function.html#command:function).

```cmake
macro(my_macro)
endmacro()
is_command(my_macro a)

function(my_function)
endfunction()
is_command(my_function b)

set(my_var "")
is_command(my_var c)

message("${a}") # true
message("${b}") # true
message("${c}") # false
```

## `is_string`

Determines if value is a string.
In this context, a value is considered to be a string, if it is:

* not [numeric](#is_numeric)
* not [boolean](#is_bool) (_`true` or `false`_)
* not a [list](#is_list) (_semicolon separated list_)
* not a [command](#is_command)

```cmake
is_string("abc" a)

set(my_str "foo")
is_string(my_str b)

is_string(42 c)

message("${a}") # true
message("${b}") # true
message("${c}") # false
```

## `get_type`

Determines the type of given value.
Function assigns a string representation of the value's type (_int, float, bool, list, command, or string_), to
the `output` argument.

* See [`is_int()`](#is_int)
* See [`is_float()`](#is_float)
* See [`is_bool()`](#is_bool)
* See [`is_list()`](#is_list)
* See [`is_command()`](#is_command)
* See [`is_string()`](#is_string)

```cmake
get_type("abc" a)
get_type("aaa;bbb;ccc" b)
get_type(true c)
get_type(12 d)

message("${a}") # string
message("${b}") # list
message("${c}") # bool
message("${c}") # int
```