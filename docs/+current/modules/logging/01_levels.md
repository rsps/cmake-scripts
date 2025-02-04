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

* `EMERGENCY_LEVEL`: _Emergency: system is unusable._
* `ALERT_LEVEL`: _Alert: action must be taken immediately._
* `CRITICAL_LEVEL`: _Critical: critical conditions._
* `ERROR_LEVEL`: _Error: error conditions._
* `WARNING_LEVEL`: _Warning: warning conditions._
* `NOTICE_LEVEL`: _Notice: normal but significant condition._
* `INFO_LEVEL`: _Informational: informational messages._
* `DEBUG_LEVEL`: _Debug: debug-level messages._

## CMake Message Modes

All the PSR log levels are associated with the following cmake [message modes](https://cmake.org/cmake/help/latest/command/message.html#general-messages).
This means that cmake's [message log level](https://cmake.org/cmake/help/latest/command/cmake_language.html#get-message-log-level)
is respected, when using any of the logging functions that are offered by this module.

| Psr Log Level     | CMake Message Mode |
|-------------------|--------------------|
| `EMERGENCY_LEVEL` | `FATAL_ERROR`      |
| `ALERT_LEVEL`     | `FATAL_ERROR`      |
| `CRITICAL_LEVEL`  | `FATAL_ERROR`      |
| `ERROR_LEVEL`     | `SEND_ERROR`       |
| `WARNING_LEVEL`   | `WARNING`          |
| `NOTICE_LEVEL`    | `NOTICE`           |
| `INFO_LEVEL`      | `NOTICE`           |
| `DEBUG_LEVEL`     | `DEBUG`            |

## Customize

To change the default PSR log level / cmake message mode association, set the `RSP_LOG_LEVELS_CMAKE` property,
before you include the `rsp/logging` module
or by [force](https://cmake.org/cmake/help/latest/command/set.html#set-cache-entry) caching the property.

Use the following format for associating the levels:

```txt
"<psr> <cmake_mode>" 
```
* _`<psr>`_: PSR log level name (_lowercase_).
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