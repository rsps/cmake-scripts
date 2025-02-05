---
title: Helpers
description: How to use the output helpers.
keywords: output, helpers, cmake
author: RSP Systems A/S
---

# Output Helpers

[TOC]

## `output()`

Outputs a message to `stdout` or `stderr`
(_[message mode](https://cmake.org/cmake/help/latest/command/message.html#general-messages) specific_).
Behind the scene, the `output()` function is a wrapper for cmake's [`message()`](https://cmake.org/cmake/help/latest/command/message.html).

It accepts the following parameters:

* < message >: _`string`, `variable` or `list` message to output._
* < mode >: (_option_), _cmake [message mode](https://cmake.org/cmake/help/latest/command/message.html#general-messages), e.g. `WARNING`, `NOTICE`, `STATUS`, ...etc._
_Defaults to `NOTICE` is mode is not specified._
* `OUTPUT`: (_optional_), _output variable. If specified, message is assigned to variable, instead of being printed to `stdout` or `stderr`._
* `LABEL`: (_optional_), _A label to display before the message._
* `LABEL_FORMAT`: (_optional_), _A format string in which the actual label is inserted. Use the `%label%` token, in which the actual label is inserted._
* `LIST_SEPARATOR`: (_optional_), _Separator to used, if a list variable is given as message. Defaults to `\n` (newline)._

### Example

```cmake
output("Building package assets" NOTICE LABEL "info")
```

The above example will print the following, using cmake's `NOTICE` mode.

```txt
info: Building package assets
```

### Capture Output

If you specify a variable for the `OUTPUT` parameter, then your message is assigned to that variable, instead of
being printed in the console.

```cmake
output("Building package assets" NOTICE OUTPUT result)

message("result = ${result}")
```

```txt
result = Building package assets
```

!!! note "Note"
    When you specify the `OUTPUT` parameter, then the message `< mode >` argument is ignored.
    As such, the following will never yield an error:

    ```cmake
    # FATAL_ERROR message mode used, but OUTPUT specified... this never fails!
    output("Should fail..." FATAL_ERROR OUTPUT output)
    
    # Message is printed...
    message("${output} but doesn't")
    ```

### Label & Label Format

When you specify a `LABEL`, then it will be printed before the actual message.
By default, the format for the rendered label is: `%label%: `, where the `%label%` token is where the label is injected.
You can customise this format, by specifying the `LABEL_FORMAT` parameter.

```cmake
output("Building package assets" NOTICE LABEL "✓" LABEL_FORMAT "[ %label% ] ")
```

```txt
[ ✓ ] Building package assets
```

You can also change the default label format, by setting the `RSP_DEFAULT_LABEL_FORMAT` property.

```cmake
set(RSP_DEFAULT_LABEL_FORMAT "( %label% ) - " CACHE STRING "Default label format...")

# ...Later in your cmake script...
output("Building package assets" NOTICE LABEL "ok")
```

```txt
( ok ) - Building package assets
```

!!! warning "Troubleshooting"
    _If your custom label format does not take effect, then it is most likely because `RSP_DEFAULT_LABEL_FORMAT` is
    cached property._

    _Consider setting `RSP_DEFAULT_LABEL_FORMAT` before you include the `rsp/output` module, or
    [force](https://cmake.org/cmake/help/latest/command/set.html#set-cache-entry) cache the property._

### Lists

`output()` is also able to print lists. By default, each item is printed on a new line.

```cmake
set(my_list "a;b;c")

output(my_list)
```

```txt
a
b
c
```

Use the `LIST_SEPARATOR` parameter to use a custom list item separator:

```cmake
set(my_list "a;b;c")

output(my_list LIST_SEPARATOR ", ")
```

```txt
a, b, c 
```