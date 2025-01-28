---
title: Forget
description: Delete a cached variable exists
keywords: cache, cmake
author: RSP Systems A/S
---

# Forget

Call `cache_forget()` to delete a cached entry. It accepts the following parameters:

* `KEY`: _The target variable to determine if it exists._
* `OUTPUT`: (_optional_), _Variable to assign delete status._

**Example**

```cmake
cache_forget(
    KEY run_cleanup
    OUTPUT was_deleted
)

if(was_deleted)
    # ...not shown...
endif ()
```