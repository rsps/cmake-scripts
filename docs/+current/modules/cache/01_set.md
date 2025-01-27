---
title: Set
description: Cache a variable
keywords: cache, cmake
author: RSP Systems A/S
---

# Set

Use `cache_set()` to cache a variable. The function accepts the following parameters:

* `KEY`: _The variable to assign and cache._
* `VALUE`: _Value to assign and cache._
* `TTL`: (_optional_), _Time-To-Live of cache entry in seconds (see [TTL](#ttl) for details)._
* `TYPE`: (_optional_), _Cmake cache entry type, BOOL, STRING,...etc. Defaults to `STRING` if not specified._
* `DESCRIPTION`: (_optional_), _Description of cache entry._

!!! warning "Caution"
    Invoking the `cache_set()` function, is the equivalent to using CMake's
    [`set(... CACHE FORCE)`](https://cmake.org/cmake/help/latest/command/set.html#set-cache-entry).

**Example**

```cmake
cache_set(
    KEY foo
    VALUE "bar"
)

message("${foo}") # bar
```

## TTL

You can optionally specify a time-to-live (_ttl_) duration (_in seconds_), for the cache entry.
Whenever the cached variable is queried (_via [`has`](./03_has.md) or [`get`](./02_get.md)_), the entry will
automatically be removed, if it has expired.

```cmake
cache_set(
    KEY foo
    VALUE "bar"
    TTL 5
)

# ... Elsewhere in your cmake scripts, 5 seconds later...

cache_get(KEY foo)

message("${foo}") # (empty string)
```
