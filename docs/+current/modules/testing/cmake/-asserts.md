---
title: Asserts
description: Assert functions
keywords: testing, assert, cmake
author: RSP Systems A/S
---

# Asserts

[TOC]

## Failure Message

All assert functions support an optional `MESSAGE` argument, which is shown if the assertion failed.

```cmake
assert_truthy(false MESSAGE "My fail msg...")
```

## Existence

### `assert_defined()`

Assert key to be defined.

```cmake
assert_defined(my_variable)
```

See https://cmake.org/cmake/help/latest/command/if.html#defined.

### `assert_not_defined()`

The opposite of `assert_defined()`. 

```cmake
assert_not_defined(my_variable)
```

## Boolean

### `assert_truthy()`

Assert key to be truthy.

```cmake
assert_truthy(my_variable)
```

See https://cmake.org/cmake/help/latest/command/if.html#basic-expressions.

### `assert_falsy()`

The opposite of `assert_truthy()`.

```cmake
assert_falsy(my_variable)
```

## Numbers

### `assert_equals()`

Assert numeric keys or values equal each other..

```cmake
assert_equals(expected actual)
```

See https://cmake.org/cmake/help/latest/command/if.html#equal.

### `assert_not_equals()`

The opposite of `assert_equals()`.

```cmake
assert_not_equals(expected actual)
```

### `assert_less_than()`

Assert numeric key or value is less than specified value.

```cmake
assert_less_than(expected actual)
```

See https://cmake.org/cmake/help/latest/command/if.html#less.

### `assert_less_than_or_equal()`

Assert numeric key or value is less than or equal to the specified value.

```cmake
assert_less_than_or_equal(expected actual)
```

See https://cmake.org/cmake/help/latest/command/if.html#less-equal.

### `assert_greater_than()`

Assert numeric key or value is greater than specified value.

```cmake
assert_greater_than(expected actual)
```

See https://cmake.org/cmake/help/latest/command/if.html#greater.

### `assert_greater_than_or_equal()`

Assert numeric key or value is greater than or equal to the specified value.

```cmake
assert_greater_than_or_equal(expected actual)
```

See https://cmake.org/cmake/help/latest/command/if.html#greater-equal.

## Strings

### `assert_string_equals()`

Assert string keys or values equal each other.

```cmake
assert_string_equals(expected actual)
```

See https://cmake.org/cmake/help/latest/command/if.html#strequal

### `assert_string_not_equals()`

Opposite of `assert_string_equals()`.

```cmake
assert_string_not_equals(expected actual)
```

### `assert_string_empty()`

Assert given string is empty.

```cmake
assert_string_empty("${my_string}")
```

See https://cmake.org/cmake/help/latest/command/string.html#length

### `assert_string_not_empty()`

Opposite of `assert_string_empty()`.

```cmake
assert_string_not_empty("${my_string}")
```

### `assert_string_contains()`

Assert given string contains substring.

```cmake
assert_string_contains("Name: John Doe" "John")
```

### `assert_string_not_contains()`

Assert given string does not contain substring.

```cmake
assert_string_not_contains("Name: John Doe" "Jimmy")
```

## Lists

### `assert_in_list()`

Assert key (value) to be in given list.

```cmake
assert_in_list(item list)
```

See https://cmake.org/cmake/help/latest/command/if.html#in-list.

### `assert_not_in_list()`

Opposite of `assert_in_list()`.

```cmake
assert_not_in_list(item list)
```

## Commands & Macros

### `assert_is_callable()`

Assert key to be a callable command or macro.

```cmake
assert_is_callable("my_function")
```

See https://cmake.org/cmake/help/latest/command/if.html#command.

### `assert_is_not_callable()`

Opposite of `assert_is_callable()`.

```cmake
assert_is_not_callable("my_unknown_function")
```

## Files & Paths

### `assert_file_exists()`

Assert file exists.

```cmake
assert_file_exists("${my_file_path}")
```

See https://cmake.org/cmake/help/latest/command/if.html#exists.

### `assert_file_not_exists()`

Opposite of `assert_file_exists()`.

```cmake
assert_file_not_exists("${my_file_path}")
```