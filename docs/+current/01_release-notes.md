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

| Version | CMake       | Release | Security Fixes Until |
|---------|-------------|---------|----------------------|
| `1.x`   | `3.30 - ?`  | _TBD_   | _TBD_                |
| `0.x`*  | `3.30 - ? ` | _TBD_   | _N/A_                |

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

