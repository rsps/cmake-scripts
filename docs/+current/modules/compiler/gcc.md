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