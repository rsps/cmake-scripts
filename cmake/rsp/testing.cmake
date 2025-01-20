# -------------------------------------------------------------------------------------------------------------- #
# Testing utilities
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/testing module included")

include("rsp/testing/asserts")

# -------------------------------------------------------------------------------------------------------------- #
# Utils. for testing cmake scripts
# -------------------------------------------------------------------------------------------------------------- #

# Path to the "test executor"
if (NOT DEFINED RSP_TEST_EXECUTOR_PATH)
    get_filename_component(RSP_TEST_EXECUTOR_PATH "${CMAKE_CURRENT_LIST_DIR}/testing/executor.cmake" REALPATH)
endif ()

# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "define_test_suite")

    #! define_test_suite : Define a test suite (a collection of test-cases)
    #
    # Warning: all test-case files in specified directory will be included,
    # by this function!
    #
    # @param <string> name              Human readable name of test suite TODO: Can this be used for ctest labels / groups?
    # @param DIRECTORY <path>           Path to directory that contains test-cases
    # @param [MATCH <glob>]             Glob used to match test-case files.
    #                                   Defaults to "*_test.cmake".
    #
    # @throws If DIRECTORY path is invalid
    #
    function(define_test_suite name)
        # Do nothing if in test exector scope...
        if (_RSP_TEST_EXECUTOR_RUNNING)
            # message(STATUS "Skipping add_ctest()")
            return()
        endif ()

        set(options "") # N/A
        set(oneValueArgs DIRECTORY MATCH)
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "DIRECTORY")
        foreach (arg ${requiredArgs})
            if (NOT DEFINED INPUT_${arg})
                message(FATAL_ERROR "${arg} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Resolve optional arguments
        if (NOT DEFINED INPUT_MATCH OR INPUT_MATCH STREQUAL "")
            set(INPUT_MATCH "*_test.cmake")
        endif ()

        # Resolve directory path
        get_filename_component(target_directory "${INPUT_DIRECTORY}" REALPATH)
        if (NOT EXISTS "${target_directory}")
            message(FATAL_ERROR "Directory \"${INPUT_DIRECTORY}\" does not exist")
        endif ()

        # Find all test-case files in directory
        file(GLOB_RECURSE test_cases "${target_directory}/${INPUT_MATCH}")
        list(LENGTH test_cases amount)

        message(STATUS "Defining ${name} | ${amount} test-cases")

        # Include each found test-case file.
        foreach (test_case ${test_cases})
            message(VERBOSE "\tIncluding test-case: ${test_case}")

            # The test-case file is expected to define one or more tests, using the
            # define_test() function...
            include("${test_case}")
        endforeach ()
    endfunction()
endif ()

if (NOT COMMAND "define_test")

    #! define_test : Define a test to be executed by the "test executor"
    #
    # @see https://cmake.org/cmake/help/latest/module/CTest.html
    # @see add_ctest_using_executor()
    #
    # @param <string> name              Human readable name of test.
    # @param <command> callback         The function that contains the actual test logic.
    # @param [EXPECT_FAILURE]           Option, if specified then callback is expected to fail.
    #
    # @throws
    #
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

        set(options EXPECT_FAILURE)
        set(oneValueArgs "")
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # ---------------------------------------------------------------------------------------------- #

        # Resolve failure expectation
        set(expected_to_fail false)
        if (INPUT_EXPECT_FAILURE)
            set(expected_to_fail true)
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Add the actual ctest
        add_ctest_using_executor(
            NAME ${name}
            CALLBACK ${callback}

            # Default the test-case file to the *.cmake file that invoked this function!
            TEST_CASE ${CMAKE_CURRENT_LIST_FILE}
            EXPECT_FAILURE ${expected_to_fail}
        )
    endfunction()
endif ()

if (NOT COMMAND "add_ctest_using_executor")

    #! add_ctest_using_executor : Add a test to be executed by "test executor", via CTest
    #
    # @see RSP_TEST_EXECUTOR_PATH
    # @see https://cmake.org/cmake/help/latest/module/CTest.html
    #
    # @param NAME <string>              Human readable name of test
    # @param CALLBACK <command>         The function that contains the actual test, in the test-case file.
    # @param TEST_CASE <path>           Path to the target *.cmake test-case file.
    # @param [EXPECT_FAILURE <bool>]    If set to true, then test callback is expected to fail.
    #                                   Default set to false.
    # @param [EXECUTOR <path>]          Path to the "test executor". Defaults to RSP_TEST_EXECUTOR_PATH,
    #                                   when not specified.
    #
    # @throws If EXECUTOR path is invalid.
    #
    function(add_ctest_using_executor)
        # Do nothing if in test exector scope...
        if (_RSP_TEST_EXECUTOR_RUNNING)
            # message(STATUS "Skipping add_ctest()")
            return()
        endif ()

        set(options "")  # N/A
        set(oneValueArgs NAME CALLBACK TEST_CASE EXPECT_FAILURE EXECUTOR)
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
        if (NOT DEFINED INPUT_EXPECT_FAILURE)
            set(INPUT_EXPECT_FAILURE false)
        endif ()
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

        # Debug
        message(VERBOSE "\tAdding test: ${INPUT_NAME}")

        # Add the actual CTest, using CMake's executable to process a script file...
        add_test(
            NAME "${INPUT_NAME}"
            COMMAND ${CMAKE_COMMAND}
                -DTEST_NAME=${INPUT_NAME}
                -DTEST_CALLBACK=${INPUT_CALLBACK}
                -DTEST_CASE=${INPUT_TEST_CASE}
                -DMODULE_PATHS=${CMAKE_MODULE_PATH}
                -P "${INPUT_EXECUTOR}"
        )

        # Set test failure expectation
        # @see https://cmake.org/cmake/help/latest/prop_test/WILL_FAIL.html#prop_test:WILL_FAIL
        set_property(TEST ${INPUT_NAME} PROPERTY WILL_FAIL "${INPUT_EXPECT_FAILURE}")

        # TODO: What about test LABELS
        # TODO: @see https://stackoverflow.com/questions/24495412/ctest-using-labels-for-different-tests-ctesttestfile-cmake

    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Internals
# -------------------------------------------------------------------------------------------------------------- #
