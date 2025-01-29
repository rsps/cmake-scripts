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