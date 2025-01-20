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
set(required "TEST_NAME;TEST_CALLBACK;TEST_CASE;MODULE_PATHS")
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
message(NOTICE "Test-Case: ${TEST_CASE}")
message(NOTICE "Before callback: ${BEFORE_CALLBACK}")
message(NOTICE "After callback: ${AFTER_CALLBACK}")
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
if (NOT EXISTS ${TEST_CASE})
    message(FATAL_ERROR "Test file \"${TEST_CASE}\" does not exist")
endif ()

# -------------------------------------------------------------------------------------------------------------- #

#! run_callback : Invokes given callback
#
# @internal
#
# @param <command> name     The command or macro to invoke e
# @param TYPE <string>    A label that describes the callback.
#
# @throws If command or macro does not exist
#
function(rsp_executor_run_callback name)
    set(oneValueArgs TYPE)
    cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})

    # Ensure required arguments are defined
    set(requiredArgs "TYPE")
    foreach (arg ${requiredArgs})
        if (NOT DEFINED INPUT_${arg})
            message(FATAL_ERROR "${arg} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
        endif ()
    endforeach ()

    # --------------------------------------------------------------------------------------- #

    if (NOT COMMAND "${name}")
        message(FATAL_ERROR "${INPUT_TYPE} callback \"${name}\" does not exist, in ${TEST_CASE}")
    endif ()

    cmake_language(CALL "${name}")
endfunction()

# -------------------------------------------------------------------------------------------------------------- #

# Test Executor's "running" state flag
#
# @internal
#
set(_RSP_TEST_EXECUTOR_RUNNING TRUE)

# Include the test file
include(${TEST_CASE})

# -------------------------------------------------------------------------------------------------------------- #
# Invoke before callback, if requested

if (DEFINED BEFORE_CALLBACK AND NOT (BEFORE_CALLBACK STREQUAL ""))
    rsp_executor_run_callback("${BEFORE_CALLBACK}" TYPE "Before")
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Invoke the test callback

rsp_executor_run_callback("${TEST_CALLBACK}" TYPE "Test")

# -------------------------------------------------------------------------------------------------------------- #
# Invoke after callback, if requested

if (DEFINED AFTER_CALLBACK AND NOT (AFTER_CALLBACK STREQUAL ""))
    rsp_executor_run_callback("${AFTER_CALLBACK}" TYPE "After")
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Finally, terminate the executor
cmake_language(EXIT 0)
