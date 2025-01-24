---
title: Version 0.x
description: Documentation for CMake Scripts version 0.x.
keywords: cmake, c++
author: RSP Systems A/S
---

# Version 0.x

!!! danger "Caution"
    "CMake Scripts" is still in development. You **SHOULD NOT** use this packages in a production environment.
    Breaking changes **MUST** be expected for all `v0.x` releases!
    
    _Please review the [changelog](https://github.com/rsps/cmake-scripts/blob/main/CHANGELOG.md) for additional details._

[TOC]

## How to install

_TODO: ...incomplete, please review documentation at a later point_

```cmake
# Abort if building in-source
include("rsp/helpers")
fail_in_source_build()

# Run only when this project is the root project
if (CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    # Setup package manager
    set(CPM_USE_NAMED_CACHE_DIRECTORIES ON)
endif()

include("CPM")
```

!!! note 
    A note...

!!! info
    Something more important

!!! warning
    A warning of some kind

!!! danger
    THIS IS very risky...

One separate stigma i give you: fear each other. It is a post-apocalyptic history, sir.
When the lotus of thought hears the satoris of the yogi, the courage will know guru.
Try decorating the olive oil chicorys with whole peppermint tea and honey, heated.
Everyone just loves the flavor of white bread chili jumbled with butter.

Strudel can be garnished with delicious peanut butter, also try decorateing the chili with champaign.
Issue doesn’t spiritually trap any wind — but the aspect is what converts.

Place the cauliflower in a bottle, and marinate quickly with instant ice water.
Confucius says: the new sinner is appearing, the popular lotus is remaining.

Nunc ultricies sagittis erat, viverra lobortis orci laoreet vitae. Fusce rutrum sem massa, eget commodo purus facilisis sit amet. Vivamus ac odio vitae eros ullamcorper malesuada at eget tortor. Integer pellentesque semper magna ac tristique. Vestibulum faucibus metus vel sem vulputate ultricies. Sed nec cursus felis, sit amet ultricies sapien. Suspendisse ornare, justo blandit posuere dapibus, lacus metus fermentum urna, nec molestie augue justo ac urna. Pellentesque ac felis non ipsum efficitur eleifend nec eget ante. Donec tortor purus, congue a leo vitae, porta condimentum enim.