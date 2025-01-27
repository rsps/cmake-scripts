---
title: Find Version Tag
description: Using git_find_version_tag
keywords: git, version, tag, cmake
author: RSP Systems A/S
---

# Find Version Tag

The `git_find_version_tag()` function allows you to find the nearest version tag that matches a version-pattern
(_local repository_). Behind the scene, [git-describe](https://git-scm.com/docs/git-describe) is invoked.

[TOC]

## Example

```cmake
include("rsp/git")

git_find_version_tag(
    OUTPUT version
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)

message("${version}") # 1.15.2
```

## Match Pattern

By default, the following [glob-pattern](https://git-scm.com/docs/git-describe#Documentation/git-describe.txt---matchltpatterngt)
is used for matching a version tag:

* `*[0-9].*[0-9].*[0-9]*`

To customize the pattern, specify the `MATCH_PATTERN` parameter.

```cmake
git_find_version_tag(
    OUTPUT pre_release
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    MATCH_PATTERN "*[0-9].*[0-9].*[0-9]-*"
)

message("${pre_release}") # 1.0.0-alpha.2
```

## Default Version

If unable to find a version tag, `"0.0.0"` is returned
(_See also [Exit on Failure](#exit-on-failure)_).
You can change this by setting the `DEFAULT` parameter, in situations when no version tag can be found.

```cmake
git_find_version_tag(
    OUTPUT version
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEFAULT "0.1.0"
)

message("${version}") # 0.1.0
```

## Exit on Failure

A fatal error will be raised, if the `EXIT_ON_FAILURE` option is set, and no version tag can be found.
When doing so, the [default version](#default-version) parameter will be ignored.

```cmake
git_find_version_tag(
    OUTPUT version
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEFAULT "0.1.0"
    EXIT_ON_FAILURE
) # Fatal Error: No version tag found ...
```

