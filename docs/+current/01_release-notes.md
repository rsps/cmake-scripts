---
title: Release Notes
description: Release Notes for CMake Scripts version 0.x.
keywords: cmake, c++
author: RSP Systems A/S
---

# Release Notes

[TOC]

## Support Policy

The following shows the supported versions of the "CMake Scripts" project.

| Version | CMake       | Release             | Security Fixes Until |
|---------|-------------|---------------------|----------------------|
| `1.x`   | `3.30 - ?`  | _TBD_               | _TBD_                |
| `0.x`*  | `3.30 - ? ` | February 13th, 2025 | _N/A_                |

_* - current supported version._ \
_TBD - "To be decided"._ \
_N/A - "Not available"._

## `v0.x` Highlights

### "Mini" Testing Framework

(_available since `v0.1`_)

A "mini" testing framework for testing your CMake modules and scripts.

```cmake
define_test("has built assets" "has_built_assets")
function(has_built_assets)
    assert_file_exists("resources/images/menu_bg.png" MESSAGE "No menu bg")
    assert_file_exists("resources/images/bg.png" MESSAGE "No background")
    
    # ...etc
endfunction()
```

See [testing module](./modules/testing/cmake/index.md) for additional information.

### Git

(_available since `v0.1`_)

Git related utilities.

```cmake
git_find_version_tag(
    OUTPUT version
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

message("${version}") # 1.15.2
```

See [git module](./modules/git/index.md) for additional information.

### Version

(_available since `v0.1`_)

Helpers for dealing with a project’s versioning

```cmake
version_from_file(
    FILE "version"
    OUTPUT my_package
)

message("${my_package}_SEMVER") # 2.0.0-beta.3+AF1004
```

See [version module](./modules/version/index.md) for additional information.

### Output

(_available since `v0.1`_)

Various output and [ANSI](./modules/output/ansi.md) utilities.

```cmake
output("Building package assets" NOTICE LABEL "✓" LABEL_FORMAT "[ %label% ] ")
```

```txt
[ ✓ ] Building package assets
```

See [output module](./modules/output/index.md) for additional information.

### Debug

(_available since `v0.1`_)

Debugging utils.

```cmake
set(resources_list "chart.png;driver.ini;config.json")

dump(
    resources_list
)
```

Outputs:

```txt
CMake Warning at cmake/rsp/debug.cmake:31 (message):
dump:

   resources_list = (list 3) [ 
      0: (string 9) "chart.png"
      1: (string 10) "driver.ini"
      2: (string 11) "config.json"
   ]
Call Stack (most recent call first):
  CMakeLists.txt:108 (dump)
```

See [debug module](./modules/debug/index.md) for additional information.


### Logging

(_available since `v0.1`_)

[PSR-3](https://www.php-fig.org/psr/psr-3/) inspired logging utilities.

```cmake
warning("Build incomplete"
    CONTEXT
        PROJECT_NAME
        CMAKE_BINARY_DIR
        CMAKE_PROJECT_NAME
)
```

```txt
CMake Warning at cmake/rsp/output.cmake:144 (message):
warning: Build incomplete

      Context: 
      [
         PROJECT_NAME = my-project
         CMAKE_BINARY_DIR = /home/user/code/my-project/build
         CMAKE_PROJECT_NAME = my-project
      ]
      Timestamp: 2025-02-05 14:49:16.087085
Call Stack (most recent call first):
  cmake/rsp/logging.cmake:335 (output)
  cmake/rsp/logging.cmake:381 (log)
  cmake/rsp/logging.cmake:158 (forward_to_log)
  CMakeLists.txt:103 (warning)
```

See [logging module](./modules/logging/index.md) for additional information.

### Cache

(_available since `v0.1`_)

Module that offers additional caching functionality (_via CMake’s Cache Entry mechanism_).

```cmake
cache_set(
    KEY foo
    VALUE "bar"
    TTL 5
)

# ... Elsewhere in your cmake scripts, 5 seconds later...

cache_get(KEY foo)

message("${foo}") # (empty string)
```

See [cache module](./modules/cache/index.md) for additional information.

## Changelog

For additional information about the latest release, new features, changes or defect fixes, please review the
[Changelog](https://github.com/rsps/cmake-scripts/blob/main/CHANGELOG.md).

