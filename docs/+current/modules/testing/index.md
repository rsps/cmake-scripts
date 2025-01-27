---
title: Testing
description: How to use the testing module.
keywords: testing, cmake
author: RSP Systems A/S
---

# Testing

"CMake Scripts" has been developed with testing in mind. To ensure that the provided functionality works as intended,
we have made an effort to write code that is testable. As a direct result of this, various testing utilities have been  
developed (_e.g. for cmake modules and scripts_), which are offered in this module.

## How to include

```cmake
include("rsp/testing")
```