# -------------------------------------------------------------------------------------------------------------- #
# Testing utilities
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/testing module included")

include("rsp/helpers")

# Path to the "test executor"
if (NOT DEFINED RSP_TEST_EXECUTOR_PATH)
    get_filename_component(RSP_TEST_EXECUTOR_PATH "${CMAKE_CURRENT_LIST_DIR}/testing/test_executor.cmake" REALPATH)
endif ()

# A temporary list of "test entries"
set(DEFINED_TESTS_LIST "")

if (NOT COMMAND "define_test")

    # TODO
    function(define_test name callback)
        # Do nothing if in test exector scope...
        if (_RSP_TEST_EXECUTOR_RUNNING)
            # message(STATUS "Skipping define_test()")
            return()
        endif ()

        # Debug
        # message("   defining test invoked: ${name}, using ${callback}")

        # Ensure required arguments are defined
        set(requiredArgs "name;callback")
        foreach (arg ${requiredArgs})
            if (NOT DEFINED ${arg} OR ${arg} STREQUAL "")
                message(FATAL_ERROR "${arg} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Create an entry with details
        make_test_entry(
            OUTPUT entry
            NAME "${name}"
            CALLBACK "${callback}"
        )

        # Append callback to list of tests to be invoked
        list(APPEND DEFINED_TESTS_LIST "${entry}")
        set(DEFINED_TESTS_LIST "${DEFINED_TESTS_LIST}" PARENT_SCOPE)
    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Internals
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "make_test_entry")
    # TODO: ...
    function(make_test_entry)
        set(options "") # N/A
        set(oneValueArgs OUTPUT NAME CALLBACK)
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "OUTPUT;NAME;CALLBACK")
        foreach (name ${requiredArgs})
            if (NOT DEFINED INPUT_${name})
                message(FATAL_ERROR "${name} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Join parts
        set("${INPUT_OUTPUT}" "${INPUT_NAME}|${INPUT_CALLBACK}")
        return(
            PROPAGATE
            "${INPUT_OUTPUT}"
        )
    endfunction()
endif ()

if (NOT COMMAND "extract_test_entry")
    # TODO: ...
    function(extract_test_entry)
        set(options "") # N/A
        set(oneValueArgs ENTRY NAME CALLBACK)
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "ENTRY;NAME;CALLBACK")
        foreach (name ${requiredArgs})
            if (NOT DEFINED INPUT_${name})
                message(FATAL_ERROR "${name} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Extract parts from test entry
        string(REPLACE "|" ";" parts "${INPUT_ENTRY}")

        # TODO: Entry indexes...
        list(GET parts 0 name)
        list(GET parts 1 callback)

        # Set output variables
        set("${INPUT_NAME}" "${name}")
        set("${INPUT_CALLBACK}" "${callback}")
        return(
            PROPAGATE
            "${INPUT_NAME}"
            "${INPUT_CALLBACK}"
        )
    endfunction()
endif ()