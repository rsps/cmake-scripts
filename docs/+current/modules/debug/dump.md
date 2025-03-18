---
title: Dump
description: How to dump variables.
keywords: debug, debugging, dump, dd, var_dump, cmake
author: RSP Systems A/S
---

# Dump Variables

[TOC]

## `dump()`

Outputs the names and values of given variables.
Behind the scene, [`var_dump()`](#var_dump) is used. 

```cmake
set(build_assets true)
set(assets_dir "/home/code/my-project/resources")

dump(
    build_assets
    assets_dir
)

message("Onward...")
```

The above will output a [`WARNING`](https://cmake.org/cmake/help/latest/command/message.html#general-messages) message,
and continue to process your cmake script:

```txt
CMake Warning at cmake/rsp/debug.cmake:31 (message):
dump:

   build_assets = (bool) true
   assets_dir = (string 31) "/home/code/my-project/resources"
Call Stack (most recent call first):
  CMakeLists.txt:132 (dump)

Onward...
```

## `dd()`

Outputs the names and values of given variables, and stops the build (_dump and die_).
Behind the scene, [`var_dump()`](#var_dump) is used.

```cmake
set(build_assets true)
set(assets_dir "/home/code/my-project/resources")

dd(
    build_assets
    assets_dir
)

# This message will never be reached!
message("Onward...")
```

The `dd()` function will output using cmake's [`FATAL_ERROR`](https://cmake.org/cmake/help/latest/command/message.html#general-messages)
message mode. Your cmake script will not continue to be processed:

```txt
CMake Error at cmake/rsp/debug.cmake:54 (message):
dd:

   build_assets = (bool) true
   assets_dir = (string 31) "/home/code/my-project/resources"
Call Stack (most recent call first):
  CMakeLists.txt:132 (dd)
```

## `var_dump()`

Outputs human-readable information about given properties.
It accepts the following parameters:

* `PROPERTIES`: _The variables to be dumped._
* `OUTPUT`: (_optional_), _output variable. If specified, message is assigned to variable, instead of being printed to `stdout` or `stderr`._
* `WITHOUT_NAMES`: (_option_), _Output information without the variable names._
* `IGNORE_LIST`: (_option_), _Variables of the type "list" are treated as "string" type instead._

!!! info "Note"
    Unless `OUTPUT` is specified, `var_dump()` will output using cmake's [`NOTICE`](https://cmake.org/cmake/help/latest/command/message.html#general-messages)
    message mode.

```cmake
set(my_str "Hi there")
set(my_empty_str "")
set(my_num 23)
set(my_float 1.1234)
set(my_bool true)
set(my_const on)
set(my_list "foo;bar;42;true")
set(my_cached_prop "My cached var..." CACHE STRING "Testing")
set(ENV{my_env_prop} "/home/other/place")

macro(my_macro)
endmacro()

function(my_function)
endfunction()

var_dump(PROPERTIES
    my_str
    my_empty_str
    my_num
    my_float
    my_const
    my_undefined_prop
    my_list
    my_cached_prop
    my_env_prop
    my_macro
    my_function
)
```

The above will output:

```txt
my_str = (string 8) "Hi there"
my_empty_str = (string 0) ""
my_num = (int) 23
my_float = (float) 1.1234
my_const = (string 2) "on"
my_undefined_prop = (undefined) 
my_list = (list 4) [ 
   0: (string 3) "foo"
   1: (string 3) "bar"
   2: (int) 42
   3: (bool) true
]
my_cached_prop = (string 4, cached) "Yolo"
my_env_prop = (string 17, ENV) "/home/other/place"
my_macro = (command) my_macro()
my_function = (command) my_function()
```

### Without Names

If the `WITHOUT_NAMES` option is set, then variable names are not part of the output.

```cmake
var_dump(
    WITHOUT_NAMES
    PROPERTIES
        my_str
)
```

Outputs:

```txt
(string 8) "Hi there"
```

### Ignore List

By default, `var_dump()` will attempt to parse any list variable and output each item on a new line.
To disable this behaviour, set the `IGNORE_LIST` option. When doing so, lists are treated as a regular string.

**Default behaviour**

```cmake
var_dump(
    PROPERTIES
        my_list
)
```

Outputs:

```txt
my_list = (list 4) [ 
   0: (string 3) "foo"
   1: (string 3) "bar"
   2: (int) 42
   3: (bool) true
]
```

**With ignore list option**

```cmake
var_dump(
    IGNORE_LIST
    PROPERTIES
        my_list
)
```

Outputs:

```txt
my_list = (string 15) "foo;bar;42;true"
```

## `var_dump_all()`

**Available Since: `v0.2.0`**

Outputs human-readable information about CMake's current defined variables.

_See Cmake's [`VARIABLES`](https://cmake.org/cmake/help/latest/prop_dir/VARIABLES.html) for additional information._

```cmake
var_dump_all()
```

Outputs:

```txt
ALERT_LEVEL = (command, cached) ALERT_LEVEL()
BUILD_TESTING = (string 0) ""
CMAKE_AUTOGEN_ORIGIN_DEPENDS = (string 2) "ON"
CMAKE_AUTOMOC_COMPILER_PREDEFINES = (string 2) "ON"
CMAKE_AUTOMOC_MACRO_NAMES = (list 4) [ 
   0: (string 8) "Q_OBJECT"
   1: (string 8) "Q_GADGET"
   2: (string 11) "Q_NAMESPACE"
   3: (string 18) "Q_NAMESPACE_EXPORT"
]
CMAKE_AUTOMOC_PATH_PREFIX = (string 3) "OFF"

... remaining not shown
```