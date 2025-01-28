---
title: Has
description: Determine if a cached variable exists
keywords: cache, cmake
author: RSP Systems A/S
---

# Has

Use `cache_has()` to determine if a cached variable exists. It accepts the following parameters:

* `KEY`: _The target variable to determine if it exists._
* `OUTPUT`: _Output variable to assign the result to._

**Example**

```cmake
cache_has(
    KEY build_assets
    OUTPUT exists
)

if(exists)
    # ...not shown...
endif ()
```

## Expired Entries

Just like [`cache_get()`](./02_get.md), the `cache_has()` function respects the expiration status of a cached variable.
If the queried variable has expired, then this function will assign `false` to the `OUTPUT` variable.
