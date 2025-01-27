---
title: Version File
description: To to work with version files
keywords: git, semver, version, file, cmake
author: RSP Systems A/S
---

# Version File(s)

In this section you can find examples on how to read and write a version string, from and to a file.

[TOC]

## Write Version File

Use `write_version_file()` to write a version string to a specified file.
The function accepts two parameters:

* `FILE`: _Path to target file in which the version must be written_
* `VERSION`: (_optional_) _The version string to write in file (see "default version" for details)._

**Example** 

```cmake
include("rsp/version")

write_version_file(
    FILE "version.txt"
    VERSION "v1.4.3"
)
```

!!! warning "Caution"
    `write_version_file()` expects the `VERSION` parameter to be a valid version string
    that can be parsed by [`semver_parse()`](./semver/parse.md). A fatal error is raised,
    if that is not the case.

**Default Version**

If the `VERSION` parameter is not specified, then [`git_find_version_tag()`](../git/find-version-tag.md) is used to
obtain the nearest version tag. This will then be written to the target version file.

## Read Version File

The `version_from_file()` can be used to read a version string from a specified file. Once a version string has been
obtained, it will be parsed using [`semver_parse`](./semver/parse.md). 

**Example**

```cmake
include("rsp/version")

version_from_file(
    FILE "version.txt"
    OUTPUT my_package
)

message("${my_package}_SEMVER") # 2.0.0-beta.3+AF1004
message("${my_package}_VERSION") # 2.0.0
```

!!! warning "Caution"
    Just like the `write_version_file()` function, the `version_from_file()` also parses the version string using 
    [`semver_parse()`](./semver/parse.md). A fatal error is raised, if the version string is not valid.

**Default Version**

If the given file does not contain a version string, then `"0.0.0"` is returned. 
To change this behaviour, specify the `DEFAULT` parameter.

```cmake
version_from_file(
    FILE "version.txt"
    OUTPUT my_package
    DEFAULT "1.0.0"
)

message("${my_package}_VERSION") # 1.0.0
```

## Exit on Failure

When the `EXIT_ON_FAILURE` option is set, the function will raise a fatal error in the following situations:

* If the version file does not exist.
* If obtained version string cannot be parsed.

The `DEFAULT` parameter will be ignored, if this option is set.

```cmake
version_from_file(
    FILE "unknown-file"
    OUTPUT my_package
    DEFAULT "1.0.0"
    EXIT_ON_FAILURE
) # Fatal Error: Version file unknown-file does not exist
```