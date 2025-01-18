# -------------------------------------------------------------------------------------------------------------- #
# Test Executor
# -------------------------------------------------------------------------------------------------------------- #
#
# Responsible for including a requested test file (*.cmake) and invoke the requested cmake function.
#

# TODO: Can this file REJECT running, if not within CTest execution process???

# ---------------------------------------------------------------------------------------------------------- #

# Abort if required variables are not defined
set(required "TEST_NAME;TEST_CALLBACK;TEST_FILE;MODULE_PATHS")
foreach (arg ${required})
    if (NOT DEFINED ${arg} OR ${arg} STREQUAL "")
        message(FATAL_ERROR "${arg} argument is missing, in test executor")
    endif ()
endforeach ()

# ---------------------------------------------------------------------------------------------------------- #

# Output a bit of information about the test that is about to be attempted executed.
# This output will be displayed when adding `--verbose` option to ctest, e.g.
#       ctest --verbose --test-dir build/tests
#
# Alternatively, using the `--output-on-failure` option, then these messages
# are only shown in case that a test fails, e.g.
#       ctest --output-on-failure --test-dir build/tests
#
message(NOTICE "\n")
message(NOTICE "Name: ${TEST_NAME}")
message(NOTICE "Callback: ${TEST_CALLBACK}")
message(NOTICE "File: ${TEST_FILE}")
message(NOTICE "Module path(s): ${MODULE_PATHS}")
message(NOTICE "\n")

# ---------------------------------------------------------------------------------------------------------- #
# Append provided paths to cmake's module path
foreach (path ${MODULE_PATHS})
    list(APPEND CMAKE_MODULE_PATH "${path}")
endforeach ()

list(REMOVE_DUPLICATES CMAKE_MODULE_PATH)

# ---------------------------------------------------------------------------------------------------------- #

# Abort if target test file does not exist
if (NOT EXISTS ${TEST_FILE})
    message(FATAL_ERROR "Test file \"${TEST_FILE}\" does not exist")
endif ()

# Disable the define_test() function
set(IGNORE_DEFINE_TEST TRUE)

# Include the test file
include(${TEST_FILE})

# ---------------------------------------------------------------------------------------------------------- #

# Fail if command does not exist...
if (NOT COMMAND "${TEST_CALLBACK}")
    message(FATAL_ERROR "Test callback \"${TEST_CALLBACK}\" does not exist, in ${TEST_FILE}")
endif ()

# Finally, invoke the test callback
cmake_language(CALL "${TEST_CALLBACK}")