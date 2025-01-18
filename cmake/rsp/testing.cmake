# -------------------------------------------------------------------------------------------------------------- #
# Testing utilities
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/testing module included")

# TODO: Cleanup...
include("rsp/helpers")

# Path to the "test executor"
if (NOT DEFINED RSP_TEST_EXECUTOR_PATH)
    get_filename_component(RSP_TEST_EXECUTOR_PATH "${CMAKE_CURRENT_LIST_DIR}/testing/executor.cmake" REALPATH)
endif ()

# -------------------------------------------------------------------------------------------------------------- #

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

        # Add the actual ctest
        add_ctest(
            NAME ${name}
            CALLBACK ${callback}

            # Default the test-case file to the *.cmake file that invoked this function!
            TEST_CASE ${CMAKE_CURRENT_LIST_FILE}
        )

    endfunction()
endif ()

if (NOT COMMAND "add_ctest")

    #! add_ctest : Add a test to be executed by the "test executor", via CTest
    #
    # @see https://cmake.org/cmake/help/latest/module/CTest.html
    #
    # @param NAME <string>          Human readable name of test
    # @param CALLBACK <command>     The function that contains the actual test, in the test-case file.
    # @param TEST_CASE <path>       Path to the target *.cmake test-case file.
    # @param [EXECUTOR <path>]      Path to the "test executor". Defaults to RSP_TEST_EXECUTOR_PATH,
    #                               when not specified.
    #
    # @throws If EXECUTOR path is invalid.
    #
    function(add_ctest)
        # Do nothing if in test exector scope...
        if (_RSP_TEST_EXECUTOR_RUNNING)
            # message(STATUS "Skipping add_ctest()")
            return()
        endif ()

        set(options "") # N/A
        set(oneValueArgs NAME CALLBACK TEST_CASE EXECUTOR)
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "NAME;CALLBACK;TEST_CASE")
        foreach (arg ${requiredArgs})
            if (NOT DEFINED INPUT_${arg})
                message(FATAL_ERROR "${arg} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Resolve optional arguments
        if (NOT DEFINED INPUT_EXECUTOR)
            set(INPUT_EXECUTOR "${RSP_TEST_EXECUTOR_PATH}")
        endif ()

        # Fail if path to test-case file is invalid
        if (NOT EXISTS "${INPUT_TEST_CASE}")
            message(FATAL_ERROR "Path to test-case is invalid: ${INPUT_TEST_CASE}")
        endif ()

        # Fail if path to test executor is invalid
        if (NOT EXISTS "${INPUT_EXECUTOR}")
            message(FATAL_ERROR "Path to \"test executor\" is invalid: ${INPUT_EXECUTOR}")
        endif ()

        # TODO: Debug
        message("\t\t${name} ${callback}")

        # Add the actual CTest, using CMake's executable to process a script file...
        add_test(
            NAME "${name}"
            COMMAND ${CMAKE_COMMAND}
                -DTEST_NAME=${INPUT_NAME}
                -DTEST_CALLBACK=${INPUT_CALLBACK}
                -DTEST_FILE=${INPUT_TEST_CASE}
                -DMODULE_PATHS=${CMAKE_MODULE_PATH}
                -P "${INPUT_EXECUTOR}"
        )

        # TODO: Add WILL_FAIL, based on entry!
        # TODO: @see https://cmake.org/cmake/help/latest/prop_test/WILL_FAIL.html#prop_test:WILL_FAIL

        # TODO: What about test LABELS
        # TODO: @see https://stackoverflow.com/questions/24495412/ctest-using-labels-for-different-tests-ctesttestfile-cmake

    endfunction()

endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Internals
# -------------------------------------------------------------------------------------------------------------- #