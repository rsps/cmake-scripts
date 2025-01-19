# -------------------------------------------------------------------------------------------------------------- #
# Test Executor
# -------------------------------------------------------------------------------------------------------------- #
#
# Responsible for including a requested test file (*.cmake) and invoke the requested cmake function.
#
# WARNING: Do NOT include this script directly into your project's cmake files. Your build will fail...!
#
# -------------------------------------------------------------------------------------------------------------- #

cmake_minimum_required(VERSION 3.30)

# Fail if executor is attempted included inside a project's CMakeLists.txt, or other cmake file
if(DEFINED CMAKE_PROJECT_NAME OR DEFINED PROJECT_NAME OR DEFINED PROJECT_IS_TOP_LEVEL)
    message(FATAL_ERROR
        "Test Executor is NOT allowed to be included in any cmake script!\n"
        "The executor is intended to be called as an external process that runs requested test (function), in the specified *.cmake test-case file. "
        "Please see official documentation for additional information. "
        "https://github.com/rsps/cmake-scripts"
    )
endif ()

# -------------------------------------------------------------------------------------------------------------- #

# Abort if required variables are not defined
set(required "TEST_NAME;TEST_CALLBACK;TEST_FILE;MODULE_PATHS")
foreach (arg ${required})
    if (NOT DEFINED ${arg} OR ${arg} STREQUAL "")
        message(FATAL_ERROR "${arg} argument is missing, in test executor")
    endif ()
endforeach ()

# -------------------------------------------------------------------------------------------------------------- #
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

# -------------------------------------------------------------------------------------------------------------- #

# Append provided paths to cmake's module path
foreach (path ${MODULE_PATHS})
    list(APPEND CMAKE_MODULE_PATH "${path}")
endforeach ()

list(REMOVE_DUPLICATES CMAKE_MODULE_PATH)

# -------------------------------------------------------------------------------------------------------------- #

# Abort if target test file does not exist
if (NOT EXISTS ${TEST_FILE})
    message(FATAL_ERROR "Test file \"${TEST_FILE}\" does not exist")
endif ()

# Test Executor's "running" state flag
#
# @internal
#
set(_RSP_TEST_EXECUTOR_RUNNING TRUE)

# Include the test file
include(${TEST_FILE})

# -------------------------------------------------------------------------------------------------------------- #

# Fail if command does not exist...
if (NOT COMMAND "${TEST_CALLBACK}")
    message(FATAL_ERROR "Test callback \"${TEST_CALLBACK}\" does not exist, in ${TEST_FILE}")
endif ()

# Finally, invoke the test callback
cmake_language(CALL "${TEST_CALLBACK}")