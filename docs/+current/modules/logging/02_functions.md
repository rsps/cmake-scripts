---
title: Log Functions
description: How use log functions.
keywords: logging, log, functions, cmake
author: RSP Systems A/S
---

# Log Functions

[TOC]

## `emergency()`

Logs an "emergency" level message.

```cmake
emergency("External power supply is unavailable")
```

The following parameters are supported:

* < message >
* < mode >: (_option_)
* `CONTEXT`: (_optional_)
* `OUTPUT`: (_optional_)
* `LIST_SEPARATOR`: (_optional_)

_See [`log()`](#log) function for parameter descriptions and examples._

## `alert()`

Logs an "alert" level message.

```cmake
alert("Storage disk is above 90% full, cleanup is required")
```

The following parameters are supported:

* < message >
* < mode >: (_option_)
* `CONTEXT`: (_optional_)
* `OUTPUT`: (_optional_)
* `LIST_SEPARATOR`: (_optional_)

_See [`log()`](#log) function for parameter descriptions and examples._

## `critical()`

Logs a "critical" level message.

```cmake
critical("Acme 3.7V Li-Po Battery Driver is unavailable, unable to continue build")
```

The following parameters are supported:

* < message >
* < mode >: (_option_)
* `CONTEXT`: (_optional_)
* `OUTPUT`: (_optional_)
* `LIST_SEPARATOR`: (_optional_)

_See [`log()`](#log) function for parameter descriptions and examples._

## `error()`

Log an "error" level message.

```cmake
error("Acme LDSv6 Driver failed loading device.ini")
```

The following parameters are supported:

* < message >
* < mode >: (_option_)
* `CONTEXT`: (_optional_)
* `OUTPUT`: (_optional_)
* `LIST_SEPARATOR`: (_optional_)

_See [`log()`](#log) function for parameter descriptions and examples._

## `warning()`

Logs a "warning" level message.

```cmake
warning("No configuration found for Acme VCMx Driver, using driver defaults")
```

The following parameters are supported:

* < message >
* < mode >: (_option_)
* `CONTEXT`: (_optional_)
* `OUTPUT`: (_optional_)
* `LIST_SEPARATOR`: (_optional_)

_See [`log()`](#log) function for parameter descriptions and examples._

## `notice()`

Logs a "notice" level message.

```cmake
notice("Acme CPU32v6xx Power Control Driver build completed")
```

The following parameters are supported:

* < message >
* < mode >: (_option_)
* `CONTEXT`: (_optional_)
* `OUTPUT`: (_optional_)
* `LIST_SEPARATOR`: (_optional_)

_See [`log()`](#log) function for parameter descriptions and examples._

## `info()`

Log an "info" level message.

```cmake
info("Started building external system assets")
```

The following parameters are supported:

* < message >
* < mode >: (_option_)
* `CONTEXT`: (_optional_)
* `OUTPUT`: (_optional_)
* `LIST_SEPARATOR`: (_optional_)

_See [`log()`](#log) function for parameter descriptions and examples._

## `debug()`

Log a "debug" level message.

```cmake
debug("Network: eth4, via pci@0004:01:00.0 (serial: e4:1d:2d:67:83:56)")
```

The following parameters are supported:

* < message >
* < mode >: (_option_)
* `CONTEXT`: (_optional_)
* `OUTPUT`: (_optional_)
* `LIST_SEPARATOR`: (_optional_)

_See [`log()`](#log) function for parameter descriptions and examples._

## `log()`

Log a message with an arbitrary level.

```cmake
log(INFO_LEVEL "Removing expired tmp files from cache storage")
```

Behind the scene, `log()` uses the [`output()`](../output/helpers.md#output) function to print messages to the console.
It supports the following parameters:

* < level >: _The PSR log level (see [`RSP_LOG_LEVELS`](./01_levels.md#psr-log-levels))_
* < message >: _`string`, `variable` or `list` message to output._
* < mode >: (_option_), _cmake [message mode](https://cmake.org/cmake/help/latest/command/message.html#general-messages), e.g. `WARNING`, `NOTICE`, `STATUS`, ...etc._
  _Defaults to the mode that is associated with the given log level (see [`RSP_LOG_LEVELS_CMAKE`](./01_levels.md#cmake-message-modes))._
* `CONTEXT`: (_optional_), _Evt. variables to output in a "context" associated with the log message._
* `OUTPUT`: (_optional_), _output variable. If specified, message is assigned to variable, instead of being printed to `stdout` or `stderr`._
* `LIST_SEPARATOR`: (_optional_), _Separator to used, if a list variable is given as message. Defaults to `\n` (newline)._

### Mode

Unless you specify the cmake [message mode](https://cmake.org/cmake/help/latest/command/message.html#general-messages), `log()` will automatically apply the mode that is associated with
the specified PSR log level (_defined by the [`RSP_LOG_LEVELS_CMAKE`](./01_levels.md#cmake-message-modes) property_).


Consequently, in situations when you need to deviate from the default associated mode, simply specify the desired
message mode.

```cmake
# Log a "warning" level message, but use a STATUS cmake message mode
log(WARNING_LEVEL "Config NOT found for VCMx Driver, using defaults" STATUS)
```

The above example will print a message similar to this:

```txt
-- warning: Config NOT found for VCMx Driver, using defaults
   Timestamp: 2025-02-05 11:33:32.190620
```

### Context

The `CONTEXT` parameter allows you to associate one or more variables with the given log entry.

```cmake
log(
    NOTICE_LEVEL "Assets build completed"
    CONTEXT
        assets_dir
        my_assets_list
)
```

The above shown example will print a message similar to this:

```txt
notice: Assets build completed
   Context: 
   [
      assets_dir = build/resources/config
      my_assets_list = graft.conf;ports.init;power.json
   ]
   Timestamp: 2025-02-05 11:08:40.912747
```

### Timestamp

By default, a timestamp is appended at the end of each logged message. 
You can modify this behaviour, and the timestamp format by changing the following predefined properties: 

| Property                   | Default                | Description                                                                                                                 |
|----------------------------|------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| `RSP_LOG_SHOW_TIMESTAMP`   | `true`                 | State whether to append timestamp for log entries, or not                                                                   |
| `RSP_LOG_TIMESTAMP_FORMAT` | `%Y-%m-%d %H:%M:%S.%f` | Timestamp format. See [CMake documentation](https://cmake.org/cmake/help/latest/command/string.html#timestamp) for details. |
| `RSP_LOG_TIMESTAMP_UTC`    | `false`                | True if timestamp is UTC, false if timestamp is local                                                                       |

!!! note "Note"
    Properties should be set before you include the `rsp/logging` module or by [force](https://cmake.org/cmake/help/latest/command/set.html#set-cache-entry) caching the property.

### Output

See ["Capture Output"](../output/helpers.md#capture-output) for additional information about the `OUTPUT` parameter.

### Lists

See [output "Lists"](../output/helpers.md#lists) for additional information about the `LIST_SEPARATOR` parameter.