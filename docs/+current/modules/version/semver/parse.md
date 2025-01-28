---
title: Parse
description: How to perse semantic version string
keywords: semver, version, parse, cmake
author: RSP Systems A/S
---

# Parse Semantic Version

`semver_parse()` parses a semantic version string and assigns the various version parts to the provided output variable. 

[TOC]

## Example

```cmake
include("rsp/version")

semver_parse(
    VERSION "v2.0.0-beta.3+AF1004"
    OUTPUT my_package
)

# (see example output below...)
```

## Output

### Full Version

The `[OUTPUT]` variable will contain the full version string, as it was provided:

```cmake
message("${my_package}") # v2.0.0-beta.3+AF1004
```

### Major, Minor and Patch

The `[OUTPUT]_VERSION` variable contains a CMake friendly version string (_major.minor.patch_)

```cmake
message("${my_package}_VERSION") # 2.0.0
```

### Semantic Version

The `[OUTPUT]_SEMVER` variable contains the full semantic version, without eventual "v" prefix.

```cmake
message("${my_package}_SEMVER") # 2.0.0-beta.3+AF1004
```

### Major Version

The `[OUTPUT]_MAJOR` variable contains the major version.

```cmake
message("${my_package}_MAJOR") # 2
```

### Minor Version

The `[OUTPUT]_MINOR` variable contains the minor version.

```cmake
message("${my_package}_MINOR") # 0
```

### Patch Version

The `[OUTPUT]_PATCH` variable contains the patch version.

```cmake
message("${my_package}_PATCH") # 0
```

### Pre-Release

The `[OUTPUT]_PRE_RELEASE` variable contains the [pre-release](https://semver.org/#spec-item-9) version.

```cmake
message("${my_package}_PRE_RELEASE") # beta.3
```
### Build Metadata

The `[OUTPUT]_BUILD_METADATA` variable contains the [build metadata](https://semver.org/#spec-item-10).

```cmake
message("${my_package}_BUILD_METADATA") # AF1004
```

## Invalid Version

A fatal error is raised, in situations when the provided version string cannot be parsed in accordance
with [Semantic Version](https://semver.org/).

```cmake
semver_parse(
    VERSION "4.11"
    OUTPUT my_package
) # Fatal Error: 4.11 is not a valid semantic version
```