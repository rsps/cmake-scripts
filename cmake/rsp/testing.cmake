# -------------------------------------------------------------------------------------------------------------- #
# Testing utilities
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/testing module included")

include("rsp/cache")
include("rsp/testing/asserts")

# -------------------------------------------------------------------------------------------------------------- #
# Utils. for testing cmake scripts
# -------------------------------------------------------------------------------------------------------------- #

# Path to the "test executor"
if (NOT DEFINED RSP_TEST_EXECUTOR_PATH)
    get_filename_component(RSP_TEST_EXECUTOR_PATH "${CMAKE_CURRENT_LIST_DIR}/testing/executor.cmake" REALPATH)
endif ()

# Current Test-Suite (temporary placeholder)
#
# @internal
#
#cache_set(KEY _RSP_CURRENT_TEST_SUITE VALUE "")

# Current Test-Case (temporary placeholder)
#
# @internal
#
#cache_set(KEY _RSP_CURRENT_TEST_CASE VALUE "")

# Current Test-Case labels (temporary placeholder)
#
# @internal
#
#cache_set(KEY _RSP_CURRENT_TEST_CASE_LABELS VALUE "")

# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "define_test_suite")

    #! define_test_suite : Define a test suite (a collection of test-cases)
    #
    # Warning: all test-case files in specified directory will be included,
    # by this function!
    #
    # Note: Function automatically invokes the `end_test_case()` after each
    # test-case file has been processed.
    #
    # @see end_test_case()
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
            # message(STATUS "Skipping define_test_suite()")
            return()
        endif ()

        # ---------------------------------------------------------------------------------------------- #

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

        # ---------------------------------------------------------------------------------------------- #

        # Abort if test-suite has no name
        if (NOT DEFINED name OR name STREQUAL "")
            message(FATAL_ERROR "name argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
        endif ()

        # ---------------------------------------------------------------------------------------------- #
        # Resolve optional arguments

        if (NOT DEFINED INPUT_MATCH OR INPUT_MATCH STREQUAL "")
            set(INPUT_MATCH "*_test.cmake")
        endif ()

        # Resolve directory path
        get_filename_component(target_directory "${INPUT_DIRECTORY}" REALPATH)
        if (NOT EXISTS "${target_directory}")
            message(FATAL_ERROR "Directory \"${INPUT_DIRECTORY}\" does not exist")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Find all test-case files in directory
        file(GLOB_RECURSE test_cases "${target_directory}/${INPUT_MATCH}")
        list(LENGTH test_cases amount)

        message(STATUS "Defining ${name} | ${amount} test-cases")

        # Set the current test-suite
        cache_set(KEY _RSP_CURRENT_TEST_SUITE VALUE "${name}")

        # Include each found test-case file.
        foreach (test_case ${test_cases})
            message(VERBOSE "\tIncluding test-case: ${test_case}")

            # The test-case file is expected to define one or more tests, using the
            # define_test() function...
            include("${test_case}")

            # End evt. defined test-case definition
            end_test_case()
        endforeach ()

        # Clear current test-suite
        cache_forget(KEY _RSP_CURRENT_TEST_SUITE)

    endfunction()
endif ()

if (NOT COMMAND "define_test_case")

    #! define_test_case : Define a test-case
    #
    # All subsequent defined tests will automatically be associated with this
    # test-case, until `end_test_case()` is invoked.
    #
    # @see define_test()
    # @see end_test_case()
    #
    # @param <string> name              Human readable name of test-case.
    # @param [LABELS <list>]            Labels to associate subsequent tests with.
    #
    # @throws
    #
    function(define_test_case name)
        # Do nothing if in test exector scope...
        if (_RSP_TEST_EXECUTOR_RUNNING)
            # message(STATUS "Skipping define_test_case()")
            return()
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        set(options "") # N/A
        set(oneValueArgs "")
        set(multiValueArgs LABELS) # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "")
        foreach (arg ${requiredArgs})
            if (NOT DEFINED INPUT_${arg})
                message(FATAL_ERROR "${arg} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # ---------------------------------------------------------------------------------------------- #

        # Abort if test-case has no name
        if (NOT DEFINED name OR name STREQUAL "")
            message(FATAL_ERROR "name argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Resolve labels for tests
        set(labels_list "")
        if (DEFINED INPUT_LABELS)
            set(labels_list "${INPUT_LABELS}")
        endif ()

        # Debug
        # message("Test-Case Labels: ${labels_list}")

        # ---------------------------------------------------------------------------------------------- #

        # Finally, set the temporary test-case related properties...
        cache_set(KEY _RSP_CURRENT_TEST_CASE VALUE "${name}")
        cache_set(KEY _RSP_CURRENT_TEST_CASE_LABELS VALUE "${labels_list}")
    endfunction()
endif ()

if (NOT COMMAND "end_test_case")

    #! end_test_case : Ends the test-case definition
    #
    # This function SHOULD be called at the end of each test-case.
    #
    function(end_test_case)
        # Do nothing if in test exector scope...
        if (_RSP_TEST_EXECUTOR_RUNNING)
            # message(STATUS "Skipping end_test_case()")
            return()
        endif ()

        # ---------------------------------------------------------------------------------------------- #
        # Clear all test-case related temporary variables...

        cache_forget(KEY _RSP_CURRENT_TEST_CASE)
        cache_forget(KEY _RSP_CURRENT_TEST_CASE_LABELS)
    endfunction()
endif ()

if (NOT COMMAND "define_test")

    #! define_test : Define a test to be executed by the "test executor"
    #
    # @see https://cmake.org/cmake/help/latest/module/CTest.html
    # @see define_test_case()
    # @see add_ctest_using_executor()
    #
    # @param <string> name              Human readable name of test.
    #                                   If a test-case has been defined, then the test-case's
    #                                   this test's name is automatically prefixed with that
    #                                   of the test-case.
    # @param <command> callback         The function that contains the actual test logic.
    # @param [EXPECT_FAILURE]           Option, if specified then callback is expected to fail.
    # @param [SKIP]                     Option, if set then test will be marked as "disabled"
    #                                   and not executed.
    #
    # @throws
    #
    function(define_test name callback)
        # Do nothing if in test exector scope...
        if (_RSP_TEST_EXECUTOR_RUNNING)
            # message(STATUS "Skipping define_test()")
            return()
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Debug
        # message("   defining test invoked: ${name}, using ${callback}")

        # Ensure required arguments are defined
        set(requiredArgs "name;callback")
        foreach (arg ${requiredArgs})
            if (NOT DEFINED ${arg} OR ${arg} STREQUAL "")
                message(FATAL_ERROR "${arg} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        set(options EXPECT_FAILURE SKIP)
        set(oneValueArgs "")
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # ---------------------------------------------------------------------------------------------- #

        # Resolve failure expectation
        set(expected_to_fail false)
        if (INPUT_EXPECT_FAILURE)
            set(expected_to_fail true)
        endif ()

        # Resolve skip state
        set(skip_test false)
        if (INPUT_SKIP)
            set(skip_test true)
        endif ()

        # Resolve evt. test-case prefixing of test name
        set(resolved_test_name "${name}")
        if (DEFINED _RSP_CURRENT_TEST_CASE AND NOT (_RSP_CURRENT_TEST_CASE STREQUAL ""))
            set(resolved_test_name "${_RSP_CURRENT_TEST_CASE} | ${resolved_test_name}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Resolve labels for test
        _resolve_test_labels(labels_list)

        # Debug
        # message("DEFINED LABELS: ${labels_list}")

        # ---------------------------------------------------------------------------------------------- #

        # Add the actual ctest
        add_ctest_using_executor(
            NAME ${resolved_test_name}
            CALLBACK ${callback}
            TEST_CASE ${CMAKE_CURRENT_LIST_FILE}

            EXPECT_FAILURE ${expected_to_fail}
            SKIP ${skip_test}
            LABELS ${labels_list}
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
    # @param [SKIP <bool>]              If set to true, then test callback is skipped.
    #                                   Default set to false.
    # @param [LABELS <list>]            Labels to associate test with.
    # @param [EXECUTOR <path>]          Path to the "test executor". Defaults to RSP_TEST_EXECUTOR_PATH,
    #                                   when not specified.
    #
    # @throws If EXECUTOR path is invalid.
    #
    function(add_ctest_using_executor)
        # Do nothing if in test exector scope...
        if (_RSP_TEST_EXECUTOR_RUNNING)
            # message(STATUS "Skipping add_ctest_using_executor()")
            return()
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        set(options "")  # N/A
        set(oneValueArgs NAME CALLBACK TEST_CASE EXPECT_FAILURE SKIP EXECUTOR)
        set(multiValueArgs LABELS) # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "NAME;CALLBACK;TEST_CASE")
        foreach (arg ${requiredArgs})
            if (NOT DEFINED INPUT_${arg})
                message(FATAL_ERROR "${arg} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # ---------------------------------------------------------------------------------------------- #
        # Resolve optional arguments

        if (NOT DEFINED INPUT_EXPECT_FAILURE)
            set(INPUT_EXPECT_FAILURE false)
        endif ()

        if (NOT DEFINED INPUT_SKIP)
            set(INPUT_SKIP false)
        endif ()

        set(labels_list "")
        if (DEFINED INPUT_LABELS)
            set(labels_list "${INPUT_LABELS}")
        endif ()

        if (NOT DEFINED INPUT_EXECUTOR)
            set(INPUT_EXECUTOR "${RSP_TEST_EXECUTOR_PATH}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Fail if path to test-case file is invalid
        if (NOT EXISTS "${INPUT_TEST_CASE}")
            message(FATAL_ERROR "Path to test-case is invalid: ${INPUT_TEST_CASE}")
        endif ()

        # Fail if path to test executor is invalid
        if (NOT EXISTS "${INPUT_EXECUTOR}")
            message(FATAL_ERROR "Path to \"test executor\" is invalid: ${INPUT_EXECUTOR}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

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

        # Skip test if needed
        # @see https://cmake.org/cmake/help/latest/prop_test/DISABLED.html
        set_property(TEST ${INPUT_NAME} PROPERTY DISABLED "${INPUT_SKIP}")

        # ---------------------------------------------------------------------------------------------- #

        # Add labels for given test, when available.
        #
        # Examples:
        #   ctest --output-on-failure --label-regex "unit" --test-dir build/tests
        #   ctest --output-on-failure --label-regex "^skip" --test-dir build/tests
        #   ctest --output-on-failure --label-regex "^asserts" --test-dir build/tests
        #
        # @see https://cmake.org/cmake/help/latest/prop_test/LABELS.html
        # @see https://stackoverflow.com/questions/24495412/ctest-using-labels-for-different-tests-ctesttestfile-cmake

        list(LENGTH labels_list amount_labels)
        if (amount_labels GREATER 0)
            set_property(TEST ${INPUT_NAME} PROPERTY LABELS "${labels_list}")
        endif ()

    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Internals
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "_resolve_test_labels")

    #! _resolve_test_labels : Resolves labels for current test
    #
    # @internal
    #
    # @param <variable> output      The variable to assign labels to
    #
    # @return
    #       output                  List of labels to associate test with
    #
    function(_resolve_test_labels output)
        # Resolve labels for test
        set(labels_list "")

        # ---------------------------------------------------------------------------------------------- #

        # Test-suite label
        cache_has(KEY _RSP_CURRENT_TEST_SUITE OUTPUT has_test_suite)
        if (has_test_suite)
            cache_get(KEY _RSP_CURRENT_TEST_SUITE)
            list(APPEND labels_list "${_RSP_CURRENT_TEST_SUITE}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Test-case label
        cache_has(KEY _RSP_CURRENT_TEST_CASE OUTPUT has_test_case)
        if (has_test_case)
            cache_get(KEY _RSP_CURRENT_TEST_CASE)
            list(APPEND labels_list "${_RSP_CURRENT_TEST_CASE}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Test-case defined labels
        cache_has(KEY _RSP_CURRENT_TEST_CASE_LABELS OUTPUT has_test_case_labels)
        if (has_test_case_labels)
            cache_get(KEY _RSP_CURRENT_TEST_CASE_LABELS)
            list(APPEND labels_list "${_RSP_CURRENT_TEST_CASE_LABELS}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Cleanup provided labels
        list(TRANSFORM labels_list TOLOWER)
        list(REMOVE_DUPLICATES labels_list)

        # Returns labels
        set("${output}" "${labels_list}")
        return(PROPAGATE "${output}")
    endfunction()
endif ()