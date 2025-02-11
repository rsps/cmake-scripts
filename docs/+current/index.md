---
title: Version 0.x
description: Documentation for CMake Scripts version 0.x.
keywords: cmake, c++
author: RSP Systems A/S
---

# Version 0.x

!!! danger "Caution"
    "CMake Scripts" is still in development. You **SHOULD NOT** use this packages in a production environment.
    Breaking changes **MUST** be expected for all `v0.x` releases!
    
    _Please review the [changelog](https://github.com/rsps/cmake-scripts/blob/main/CHANGELOG.md) for additional details._

[TOC]

## How to install

### Via CPM

If you are using [CPM](https://github.com/cpm-cmake/CPM.cmake), then you can install "CMake Scripts" using the following:

```cmake
set(RSP_CMAKE_SCRIPTS_VERSION "0.1.0")

CPMAddPackage(
    NAME "rsp-cmake-scripts"
    VERSION "${RSP_CMAKE_SCRIPTS_VERSION}"
    GITHUB_REPOSITORY "rsps/cmake-scripts"
)

# IMPORTANT: Enable "rsp/*" modules in your project,...
list(APPEND CMAKE_MODULE_PATH "${rsp-cmake-scripts_SOURCE_DIR}/cmake")
```

!!! info "`CMAKE_MODULE_PATH`"
    At the time of this writing, CPM does not automatically support paths appended to `CMAKE_MODULE_PATH`.
    To make use of this package's cmake modules, via CPM, you **MUST** manually append
    this package's module path in your top-level `CMakeLists.txt`, as shown in the above install example.

### Via Fetch Content

Alternatively, you can also use cmake's [`FetchContent`](https://cmake.org/cmake/help/latest/module/FetchContent.html) module:

```cmake
set(RSP_CMAKE_SCRIPTS_VERSION "0.1.0")

include(FetchContent)
FetchContent_Declare(
    "rsp-cmake-scripts"
    GIT_REPOSITORY "https://github.com/rsps/cmake-scripts"
    GIT_TAG "${RSP_CMAKE_SCRIPTS_VERSION}"
)
FetchContent_MakeAvailable("rsp-cmake-scripts")
```

!!! note "Note"
    "CMake Scripts" depends on [CPM](https://github.com/cpm-cmake/CPM.cmake) for its dependencies. It will
    automatically be included, even when you install this project using cmake's `FetchContent` module. 
