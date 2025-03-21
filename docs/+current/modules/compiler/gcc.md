---
title: GCC
description: How to use the compiler module.
keywords: gcc, compiler, cmake
author: RSP Systems A/S
---

# GCC

Helpers and utilities that are specific for [GNU Compiler Collection (GCC)](https://gcc.gnu.org/).

[TOC]

## Compile Option Presets

### Strict

Use `RSP_GCC_STRICT_COMPILE_OPTIONS` preset when you wish to enable strict compile options.

```cmake
include("rsp/compiler")

add_compile_options(${RSP_GCC_STRICT_COMPILE_OPTIONS})
```

For additional information, please review the `RSP_GCC_STRICT_COMPILE_OPTIONS` list, in the source code.

### Customize

If you need to customise a preset, create a copy of the desired preset, and use cmake's
[list](https://cmake.org/cmake/help/latest/command/list.html#list) operations to remove or append options.

```cmake
# Copy provided preset into new variable
set(my_compile_options "${RSP_GCC_STRICT_COMPILE_OPTIONS}")

# Modify your preset...
list(REMOVE_ITEM my_compile_options "-Wswitch-default")
```

## `gcc_info()`

**Available Since: `v0.3.0`**

Obtains the path and version of the installed GCC version. The function accepts the following parameters:

* `OUTPUT`: _Output variable to assign the result to._

**Output**

* `[OUTPUT]`: _Path to installed GCC tool._
* `[OUTPUT]_VERSION`: _GCC version._

**Example**

```cmake
gcc_info(OUTPUT gcc)

message("GCC (path): ${gcc}") # /usr/bin/g++-14
message("GCC (version): ${gcc_VERSION}") # 14.2.0
```

## `gcc_version()`

**Available Since: `v0.2.0`**

Obtains the installed GCC version. The function accepts the following parameters:

* `OUTPUT`: _Output variable to assign the result to._

```cmake
gcc_version(OUTPUT version)

message("GCC: ${version}") # 14.2.0
```
