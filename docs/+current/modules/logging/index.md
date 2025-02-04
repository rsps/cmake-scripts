---
title: Logging
description: How to use the logging module.
keywords: logging, log, cmake
author: RSP Systems A/S
---

# Logging

The `logging` module offers an adaptation and implementation of the
[PSR-3: Logger Interface](https://www.php-fig.org/psr/psr-3/). It offers a series of predefined logging functions,
that are able to print a pre-formatted message to the console.
Behind the scene, the [`output()`](../output/helpers.md#output) function is used.

## How to include

```cmake
include("rsp/logging")
```

## Example

```cmake
warning("Unable to find config.json")
```

The above shown example will print a message in the console, that is similar to the following:

```txt
CMake Warning at cmake/rsp/output.cmake:144 (message):
warning: Unable to find config.json

      Timestamp: 2025-02-04 15:31:52.120599
Call Stack (most recent call first):
  cmake/rsp/logging.cmake:337 (output)
  cmake/rsp/logging.cmake:383 (log)
  cmake/rsp/logging.cmake:158 (forward_to_log)
  CMakeLists.txt:10 (warning)
```