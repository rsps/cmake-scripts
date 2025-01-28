---
title: Get
description: Retrieve a cached variable
keywords: cache, cmake
author: RSP Systems A/S
---

# Get

You can use the `cache_get()` function to retrieve a cached variable. It accepts the following parameters:

* `KEY`: _The variable to assign resulting value to._
* `DEFAULT`: (_optional_), _Default value to assign, if no cache entry found._

**Example**

```cmake
cache_get(
    KEY perform_cleanup
    DEFAULT "false"
)

if(perform_cleanup)
    # ...not shown...
endif ()
```

## Expired Entries

The benefit of using this function to retrieve a cached variable, is that it will automatically detect if the
cached entry has expired. If this is the case, then the expired variable will be deleted.
If a `DEFAULT` parameter has been specified, then that value is returned instead of an empty string. 

```cmake
cache_set(
    KEY perform_cleanup
    VALUE "true"
    TYPE "BOOL"
    TTL 60
)

# ... Elsewhere in your cmake scripts, 60 seconds later...

cache_get(
    KEY perform_cleanup
    DEFAULT "false"
)

if(perform_cleanup)
    # ...not shown...
endif ()
```
