---
title: Log Levels
description: How customise log levels.
keywords: logging, log, levels, setup, cmake
author: RSP Systems A/S
---

# Log Levels

[TOC]

## PSR Log Levels

The logging module defines the following log levels (_severities_), from
[PSR-3: Logger Interface](https://www.php-fig.org/psr/psr-3/) - (_In accordance with [RFC 5424](https://datatracker.ietf.org/doc/html/rfc5424)_).

| Psr Log Level     | Description                       |
|-------------------|-----------------------------------|
| `EMERGENCY_LEVEL` | System is unusable.               |
| `ALERT_LEVEL`     | Action must be taken immediately. |
| `CRITICAL_LEVEL`  | Critical conditions.              |
| `ERROR_LEVEL`     | Error conditions.                 |
| `WARNING_LEVEL`   | Warning conditions.               |
| `NOTICE_LEVEL`    | Normal but significant condition. |
| `INFO_LEVEL`      | Informational messages.           |
| `DEBUG_LEVEL`     | Debug-level messages.             |

## CMake Message Modes

All the PSR log levels are associated with the following cmake [message modes](https://cmake.org/cmake/help/latest/command/message.html#general-messages).
This means that cmake's [current log level](https://cmake.org/cmake/help/latest/command/cmake_language.html#get-message-log-level)
is respected, when using any of the logging functions that are offered by this module.

| Psr Log Level     | CMake Message Mode | Mode Description                                         |
|-------------------|--------------------|----------------------------------------------------------|
| `EMERGENCY_LEVEL` | `FATAL_ERROR`      | CMake Error, stops processing and generation.            |
| `ALERT_LEVEL`     | `FATAL_ERROR`      | CMake Error, stops processing and generation.            |
| `CRITICAL_LEVEL`  | `FATAL_ERROR`      | CMake Error, stops processing and generation.            |
| `ERROR_LEVEL`     | `SEND_ERROR`       | CMake Error, continues processing, but skips generation. |
| `WARNING_LEVEL`   | `WARNING`          | CMake Warning, continues processing.                     |
| `NOTICE_LEVEL`    | `NOTICE`           | Important message printed to stderr.                     |
| `INFO_LEVEL`      | `NOTICE`           | Important message printed to stderr.                     | 
| `DEBUG_LEVEL`     | `DEBUG`            | Detailed informational messages intended for developers. |

## Customize

To change the default PSR log level / cmake message mode association, set the `RSP_LOG_LEVELS_CMAKE` list property,
before you include the `rsp/logging` module
or by [force](https://cmake.org/cmake/help/latest/command/set.html#set-cache-entry) caching the property.

Use the following format for associating the levels:

```txt
"<psr> <cmake_mode>" 
```
* _`<psr>`_: PSR log level name.
* _`<cmake_mode>`_: cmake's [message modes](https://cmake.org/cmake/help/latest/command/message.html#general-messages).

```cmake
set(RSP_LOG_LEVELS_CMAKE
    "${EMERGENCY_LEVEL} FATAL_ERROR"
    "${ALERT_LEVEL} FATAL_ERROR"
    "${CRITICAL_LEVEL} FATAL_ERROR"
    "${ERROR_LEVEL} FATAL_ERROR"
    "${WARNING_LEVEL} WARNING"
    "${NOTICE_LEVEL} NOTICE"
    "${INFO_LEVEL} STATUS"
    "${DEBUG_LEVEL} STATUS"

    CACHE STRING "Log levels / message mode"
)
```