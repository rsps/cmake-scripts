---
title: Build Info
description: Using git_find_version_tag
keywords: debug, debugging, build info, cmake
author: RSP Systems A/S
---

# Build Info

The `build_info()` function dumps build information about the current build.
It accepts the following parameter:

* < mode >: (_option_), _cmake [message mode](https://cmake.org/cmake/help/latest/command/message.html#general-messages), e.g. `WARNING`, `NOTICE`, `STATUS`, ...etc._
  _Defaults to `NOTICE` is mode is not specified._
* `OUTPUT`: (_optional_), _output variable. If specified, message is assigned to variable, instead of being printed to `stdout` or `stderr`._

## Example

```cmake
set(LIB_TYPE "SHARED")

build_info()
```

Outputs a message similar to this (_not all properties are shown in example_):

```txt
build info:
 Type: Debug
 Library Type: SHARED
 Compiler flags: ...
 Compiler cxx debug flags: ... 
 Compiler cxx release flags: ...
 Compiler cxx min size flags: ...
 Compiler cxx flags: ...
```
