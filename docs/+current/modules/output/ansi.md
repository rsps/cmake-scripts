---
title: ANSI
description: How to use the ansi module.
keywords: output, ansi, cmake
author: RSP Systems A/S
---

# ANSI

The `rsp/output` modules comes with support for [ANSI](https://en.wikipedia.org/wiki/ANSI_escape_code), which will
allow you to format and style your console output.

[TOC]

## How to enable

To enable ANSI output, call the `enable_ansi()`. It is **recommended** that you only do so, if your project is the
top-level cmake project.

```cmake
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    include("rsp/output")

    enable_ansi()
endif()
```

!!! warning "Warning"
    The `enable_ansi()` caches preset of ANSI escape sequences. This means that even if you remove
    the function call, ANSI will remain enabled, unless you explicitly [disable it](#how-to-disable) again.

## How to disable

```cmake
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    include("rsp/output")

    disable_ansi()
endif()
```

## Example

Once you have enabled ANSI for your project, then you can use a series of predefined properties (_ANSI escape sequences_)
are available throughout your cmake scripts. These can be used to format your console output messages.

```cmake
message("${COLOR_GREEN}${TEXT_ITALIC}Build success${RESTORE}, for ${PROJECT_NAME}")
```

The above shown example should output a message, where the first part is in green coloured, and italic styled text. 
The second part should be in normal styled text.

> <span style="color: green; font-style: italic;">Build success</span>, for < your-cmake-project-name >

## Restore

Use the `RESTORE` (_[`ESC[0m`](https://en.wikipedia.org/wiki/ANSI_escape_code#Control_Sequence_Introducer_commands)_)
property if you wish to reset any previous set colour or style.

```cmake
message("${TEXT_BOLD}Component:${RESTORE} ready")
```

> **Component:** ready

## Text Styles

The following shows the default preset [text styles](https://en.wikipedia.org/wiki/ANSI_escape_code#Select_Graphic_Rendition_parameters):

| Property                     | Name                      | Control Sequence Code | Example                                                                                                                                         |
|------------------------------|---------------------------|----------------------:|-------------------------------------------------------------------------------------------------------------------------------------------------|
| `TEXT_BOLD`                  | bold                      |                     1 | **My style**                                                                                                                                    |
| `TEXT_BOLD_RESTORE`          | bold (_restore_)          |                    22 | My style                                                                                                                                        |
| `TEXT_DIM`                   | dim                       |                     2 | <span style="filter: brightness(50%)">My style</span>                                                                                           |
| `TEXT_DIM_RESTORE`           | dim (_restore_)           |                    22 | My style                                                                                                                                        |
| `TEXT_ITALIC`                | italic                    |                     3 | _My style_                                                                                                                                      | 
| `TEXT_ITALIC_RESTORE`        | italic (_restore_)        |                    23 | My style                                                                                                                                        |
| `TEXT_UNDERLINE`             | underline                 |                     4 | <span style="text-decoration: underline">My style</span>                                                                                        |
| `TEXT_UNDERLINE_RESTORE`     | underline (_restore_)     |                    24 | My style                                                                                                                                        |
| `TEXT_BLINK`                 | blink                     |                     5 | <style>.blink { animation: blinker 1s linear infinite; } @keyframes blinker { 50% { opacity: 35% } }</style><span class="blink">My style</span> |
| `TEXT_BLINK_RESTORE`         | blink (_restore_)         |                    25 | My style                                                                                                                                        |
| `TEXT_INVERSE`               | inverse                   |                     7 | <span style="filter: invert(100%);">My style</span>                                                                                             | 
| `TEXT_INVERSE_RESTORE`       | inverse (_restore_)       |                    27 | My style                                                                                                                                        |
| `TEXT_HIDDEN`                | hidden                    |                     8 | <span style="visibility: hidden;">My style</span>                                                                                               |                                                                                                                                                |
| `TEXT_HIDDEN_RESTORE`        | inverse (_restore_)       |                    28 | My style                                                                                                                                        |
| `TEXT_STRIKETHROUGH`         | strikethrough             |                     9 | <span style="text-decoration: line-through;">My style</span>                                                                                    |
| `TEXT_STRIKETHROUGH_RESTORE` | strikethrough (_restore_) |                    29 | My style                                                                                                                                        |

!!! note "Note"
    _Depending on your terminal, not all text styles might be supported!_

## Colours

The following default foreground and background [colours](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors) are
supported:

| Property                  | Name                          | Control Sequence Code | Example                                                                        |
|---------------------------|-------------------------------|----------------------:|--------------------------------------------------------------------------------|
| `COLOR_BLACK`             | black                         |                    30 | <div>My Style</div>                                                            | 
| `COLOR_BG_BLACK`          | black (_background_)          |                    40 | <div style="background-color: #000; color: #fff">My Style</div>                | 
| `COLOR_BRIGHT_BLACK`      | black bright                  |                    90 | <div style="color: rgb(85, 85, 85);">My Style</div>                            | 
| `COLOR_BRIGHT_BG_BLACK`   | black bright (_background_)   |                   100 | <div style="background-color: rgb(85, 85, 85); color: #fff">My Style</div>     |
| `COLOR_RED`               | red                           |                    31 | <div style="color: rgb(170, 0, 0);">My Style</div>                             | 
| `COLOR_BG_RED`            | red (_background_)            |                    41 | <div style="background-color: rgb(170, 0, 0); color: #fff">My Style</div>      | 
| `COLOR_BRIGHT_RED`        | red bright                    |                    91 | <div style="color: rgb(255, 85, 85);">My Style</div>                           | 
| `COLOR_BRIGHT_BG_RED`     | red bright (_background_)     |                   101 | <div style="background-color: rgb(255, 85, 85); color: #fff;">My Style</div>   |
| `COLOR_GREEN`             | green                         |                    32 | <div style="color: rgb(0, 170, 0);">My Style</div>                             | 
| `COLOR_BG_GREEN`          | green (_background_)          |                    42 | <div style="background-color: rgb(0, 170, 0); color: #fff">My Style</div>      | 
| `COLOR_BRIGHT_GREEN`      | green bright                  |                    92 | <div style="color: rgb(85, 255, 85);">My Style</div>                           | 
| `COLOR_BRIGHT_BG_GREEN`   | green bright (_background_)   |                   102 | <div style="background-color: rgb(85, 255, 85); color: #000;">My Style</div>   |
| `COLOR_YELLOW`            | yellow                        |                    33 | <div style="color: rgb(170, 85, 0);">My Style</div>                            |
| `COLOR_BG_YELLOW`         | yellow (_background_)         |                    43 | <div style="background-color: rgb(170, 85, 0); color: #fff">My Style</div>     |
| `COLOR_BRIGHT_YELLOW`     | yellow bright                 |                    93 | <div style="color: rgb(255, 255, 85);">My Style</div>                          |
| `COLOR_BRIGHT_BG_YELLOW`  | yellow bright (_background_)  |                   103 | <div style="background-color: rgb(255, 255, 85); color: #000;">My Style</div>  |
| `COLOR_BLUE`              | blue                          |                    34 | <div style="color: rgb(0, 0, 170);">My Style</div>                             |
| `COLOR_BG_BLUE`           | blue (_background_)           |                    44 | <div style="background-color: rgb(0, 0, 170); color: #fff">My Style</div>      |
| `COLOR_BRIGHT_BLUE`       | blue bright                   |                    94 | <div style="color: rgb(85, 85, 255);">My Style</div>                           |
| `COLOR_BRIGHT_BG_BLUE`    | blue bright (_background_)    |                   104 | <div style="background-color: rgb(85, 85, 255); color: #fff;">My Style</div>   |
| `COLOR_MAGENTA`           | magenta                       |                    35 | <div style="color: rgb(170, 0, 170);">My Style</div>                           |
| `COLOR_BG_MAGENTA`        | magenta (_background_)        |                    45 | <div style="background-color: rgb(170, 0, 170); color: #fff">My Style</div>    |
| `COLOR_BRIGHT_MAGENTA`    | magenta bright                |                    95 | <div style="color: rgb(255, 85, 255);">My Style</div>                          |
| `COLOR_BRIGHT_BG_MAGENTA` | magenta bright (_background_) |                   105 | <div style="background-color: rgb(255, 85, 255); color: #fff;">My Style</div>  |
| `COLOR_CYAN`              | cyan                          |                    36 | <div style="color: rgb(0, 170, 170);">My Style</div>                           |
| `COLOR_BG_CYAN`           | cyan (_background_)           |                    46 | <div style="background-color: rgb(0, 170, 170); color: #fff">My Style</div>    |
| `COLOR_BRIGHT_CYAN`       | cyan bright                   |                    96 | <div style="color: rgb(85, 255, 255);">My Style</div>                          |
| `COLOR_BRIGHT_BG_CYAN`    | cyan bright (_background_)    |                   106 | <div style="background-color: rgb(85, 255, 255); color: #000;">My Style</div>  |
| `COLOR_WHITE`             | white                         |                    37 | <div style="color: rgb(170, 170, 170);">My Style</div>                         |
| `COLOR_BG_WHITE`          | white (_background_)          |                    47 | <div style="background-color: rgb(170, 170, 170); color: #fff">My Style</div>  |
| `COLOR_BRIGHT_WHITE`      | white bright                  |                    97 | <div style="color: rgb(255, 255, 255);">My Style</div>                         |
| `COLOR_BRIGHT_BG_WHITE`   | white bright (_background_)   |                   107 | <div style="background-color: rgb(255, 255, 255); color: #000;">My Style</div> |
| `COLOR_DEFAULT`           | default (_reset foreground_)  |                    39 | My Style                                                                       |
| `COLOR_BG_DEFAULT`        | default (_reset background_)  |                    49 | My Style                                                                       |

!!! note "Note"
    _Depending on your terminal, colours might be rendered different from the above shown examples!_

## Your own styles

To customise the default preset, set the `RSP_ANSI_PRESET` list property, before [enabling ANSI](#how-to-enable).
Use the following format for declaring your own styles and colours:

```
"<variable> <code>[|<code>]..." 
```
* _`<variable>`_: name of your style or colour.
* _`<code>`_: control sequence [code](https://en.wikipedia.org/wiki/ANSI_escape_code#Select_Graphic_Rendition_parameters).
* _`|`_: separator (_when you define a style that uses multiple codes_)


```cmake
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    include("rsp/output")

    set(RSP_ANSI_PRESET
        "RESTORE 0"

        "MY_STYLE 1|31|23" # Set style to bold, italic, and red foreground.

        "TEXT_BOLD 1"
        "TEXT_DIM 2"

        # ... remaining not shown ...

        # RECOMMENDED: you should cache your preset!
        CACHE STRING "My custom ANSI preset"
    )
    
    enable_ansi()
endif()
```

!!! info "Tip: disable and re-enable"
    _If you have customised the default provided ANSI preset, and your styles and colours have not taken effect,
    it could be caused of by previous cached preset._

    _To resolve such an issue, [disable](#how-to-disable) and then [re-enable](#how-to-enable) ANSI. Doing so will clear previous
    cached properties and cache your custom preset._
