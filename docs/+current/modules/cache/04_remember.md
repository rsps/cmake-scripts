---
title: Remember
description: Retrieve a cache variable, or create it if it does not exist
keywords: cache, cmake
author: RSP Systems A/S
---

# Remember

`cache_remember()` is responsible for retrieve cached entry if it exists, or invoke callback and cache resulting
output value of the callback.

The following parameters are accepted:

* `KEY`: _ The variable to assign and cache._
* `CALLBACK`: _ The function or macro that returns value to be cached, if `KEY` hasn't already been cached._
* `TTL`: (_optional_), _Time-To-Live of cache entry in seconds (see [TTL](./01_set.md#ttl) for details)._
* `TYPE`: (_optional_), _Cmake cache entry type, BOOL, STRING,...etc. Defaults to `STRING` if not specified._
* `DESCRIPTION`: (_optional_), _Description of cache entry._

**Example**

```cmake
function(make_asset_uuid output)
    # ...complex logic for generating a UUID... (not shown here)...
    set("${output}" "...")
    
    # Assign to "output" variable
    return(PROPAGATE "${output}")
endfunction()

cache_remember(
    KEY assert_uuid
    CALLBACK "make_asset_uuid"
)

message("${assert_uuid}") # E.g. 2786d7fb-6d88-4878-b1f6-4c66cee31700
```