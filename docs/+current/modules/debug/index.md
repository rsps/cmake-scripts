---
title: Debug
description: How to use the debug module.
keywords: debug, debugging, cmake
author: RSP Systems A/S
---

# Debug

The debug module offers a few functions that might help you debug your cmake scripts.

## How to include

```cmake
include("rsp/debug")
```

## Example

```cmake
dump(
    CMAKE_MODULE_PATH
    CMAKE_CURRENT_LIST_FILE
)
```

The above example will output:

```txt
CMake Warning at cmake/rsp/debug.cmake:31 (message):
dump:

   CMAKE_MODULE_PATH = (string 35) "/home/code/cmake-scripts/cmake"
   CMAKE_CURRENT_LIST_FILE = (string 44) "/home/code/cmake-scripts/CMakeLists.txt"
Call Stack (most recent call first):
  CMakeLists.txt:129 (dump)
```