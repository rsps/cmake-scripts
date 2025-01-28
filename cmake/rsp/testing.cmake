# -------------------------------------------------------------------------------------------------------------- #
# Testing utilities
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/testing module included")

include("rsp/helpers")
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

# Current Test-Case before callback
#
# @internal
#
#cache_set(KEY _RSP_CURRENT_TEST_CASE_BEFORE_CALLBACK VALUE "")

# Current Test-Case after callback
#
# @internal
#
#cache_set(KEY _RSP_CURRENT_TEST_CASE_AFTER_CALLBACK VALUE "")

# Current Test-Case "run serial"
#
# @internal
#
#cache_set(KEY _RSP_CURRENT_TEST_CASE_RUN_SERIAL VALUE "")

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
    # @param <string> name              Human readable name of test suite
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
        requires_arguments(INPUT "DIRECTORY")

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

        message(STATUS "Defining \"${name}\" test suite | ${amount} test-cases (${PROJECT_NAME})")

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
    # @param [BEFORE <command>]         Command or macro to execute before each test in test-case.
    # @param [AFTER <command>]          Command or macro to execute after each test in test-case.
    # @param [LABELS <list>]            Labels to associate subsequent tests with.
    # @param [RUN_SERIAL]               Option, If specified tests in this test-case are prevent
    #                                   from running in parallel with other tests.
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

        set(options RUN_SERIAL)
        set(oneValueArgs BEFORE AFTER)
        set(multiValueArgs LABELS) # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

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

            # Escape semicolon, before value is cached
            string(REPLACE ";" "|" labels_list "${labels_list}")
        endif ()

        # Resolve "run serial"
        set(enforce_serial_run false)
        if (INPUT_RUN_SERIAL)
            set(enforce_serial_run true)
        endif ()

        # Debug
        # message("Test-Case Labels: ${labels_list}")

        # ---------------------------------------------------------------------------------------------- #

        # Finally, set the temporary test-case related properties...
        cache_set(KEY _RSP_CURRENT_TEST_CASE VALUE "${name}")
        cache_set(KEY _RSP_CURRENT_TEST_CASE_LABELS VALUE "${labels_list}")
        cache_set(KEY _RSP_CURRENT_TEST_CASE_RUN_SERIAL VALUE "${enforce_serial_run}" TYPE "BOOL")

        if (DEFINED INPUT_BEFORE)
            cache_set(KEY _RSP_CURRENT_TEST_CASE_BEFORE_CALLBACK VALUE "${INPUT_BEFORE}")
        endif ()
        if (DEFINED INPUT_AFTER)
            cache_set(KEY _RSP_CURRENT_TEST_CASE_AFTER_CALLBACK VALUE "${INPUT_AFTER}")
        endif ()
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
        cache_forget(KEY _RSP_CURRENT_TEST_CASE_BEFORE_CALLBACK)
        cache_forget(KEY _RSP_CURRENT_TEST_CASE_AFTER_CALLBACK)
        cache_forget(KEY _RSP_CURRENT_TEST_CASE_RUN_SERIAL)
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
    # @param [DATA_PROVIDER <command>]  Command or macro that provides data-set(s) for the test.
    #                                   The command or macro MUST accept a single <output> variable,
    #                                   used to assign a list of items (data-set), which will be
    #                                   passed on to the test callback.
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
        set(multiValueArgs DATA_PROVIDER) # N/A

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

        # Resolve eventual before and after callbacks
        cache_get(KEY _RSP_CURRENT_TEST_CASE_BEFORE_CALLBACK DEFAULT "")
        cache_get(KEY _RSP_CURRENT_TEST_CASE_AFTER_CALLBACK DEFAULT "")

        # Resolve "run serial" flag
        cache_get(KEY _RSP_CURRENT_TEST_CASE_RUN_SERIAL DEFAULT "false")

        # ---------------------------------------------------------------------------------------------- #
        # If a data provider callback has been given, then it must be processed.

        if (DEFINED INPUT_DATA_PROVIDER AND NOT (INPUT_DATA_PROVIDER STREQUAL ""))
            # Abort if the data provider callback does not exist.
            if (NOT COMMAND "${INPUT_DATA_PROVIDER}")
                message(FATAL_ERROR "Data Provider callback (${INPUT_DATA_PROVIDER}) does not exist, in ${CMAKE_CURRENT_LIST_FILE}")
            endif ()

            # Invoke the data provider callback
            set(data_sets "")
            cmake_language(CALL "${INPUT_DATA_PROVIDER}" data_sets)

            # Abort if data sets are empty
            list(LENGTH data_sets amount)
            if (amount LESS_EQUAL 0)
                message(FATAL_ERROR
                    "Data Provider (${INPUT_DATA_PROVIDER}) does not provide any data, in ${CMAKE_CURRENT_LIST_FILE}\n"
                    "Please make sure that the data provider callback accepts an <output> variable, "
                    "and assign your data-set(s) to that given variable."
                )
            endif ()

            # Foreach data-set, add a test.
            set(index "0")
            foreach (data_set ${data_sets})
                # Create a "new" test name, for given data-set
                set(test_name_for_data_set "${resolved_test_name} : ${index}")

                # Debug
                message(VERBOSE "\tAdding test for data-set: ${data_set}")

                add_ctest_using_executor(
                    NAME ${test_name_for_data_set}
                    CALLBACK ${callback}
                    TEST_CASE ${CMAKE_CURRENT_LIST_FILE}

                    # Provide additional test callback argument(s)
                    CALLBACK_ARG ${data_set}

                    RUN_SERIAL ${_RSP_CURRENT_TEST_CASE_RUN_SERIAL}

                    BEFORE_CALLBACK ${_RSP_CURRENT_TEST_CASE_BEFORE_CALLBACK}
                    AFTER_CALLBACK ${_RSP_CURRENT_TEST_CASE_AFTER_CALLBACK}

                    EXPECT_FAILURE ${expected_to_fail}
                    SKIP ${skip_test}
                    LABELS ${labels_list}
                )

                math(EXPR index "${index} + 1")
            endforeach ()

            # Stop further processing...
            return()
        endif ()

        # ---------------------------------------------------------------------------------------------- #
        # Otherwise, just add a regular test...

        add_ctest_using_executor(
            NAME ${resolved_test_name}
            CALLBACK ${callback}
            TEST_CASE ${CMAKE_CURRENT_LIST_FILE}

            RUN_SERIAL ${_RSP_CURRENT_TEST_CASE_RUN_SERIAL}

            BEFORE_CALLBACK ${_RSP_CURRENT_TEST_CASE_BEFORE_CALLBACK}
            AFTER_CALLBACK ${_RSP_CURRENT_TEST_CASE_AFTER_CALLBACK}

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
    # @param NAME <string>                  Human readable name of test
    # @param CALLBACK <command>             The function that contains the actual test, in the test-case file.
    # @param TEST_CASE <path>               Path to the target *.cmake test-case file.
    # @param [CALLBACK_ARG <string|list>]   Evt. data-set list to be passed on to the test callback as a
    #                                       single argument.
    # @param [BEFORE_CALLBACK <command>]    Command or macro to execute before test.
    # @param [AFTER_CALLBACK <command>]     Command or macro to execute after test.
    # @param [EXPECT_FAILURE <bool>]        If set to true, then test callback is expected to fail.
    #                                       Default set to false.
    # @param [SKIP <bool>]                  If set to true, then test callback is skipped.
    #                                       Default set to false.
    # @param [LABELS <list>]                Labels to associate test with.
    # @param [RUN_SERIAL <bool>]            If true tests in this test-case are prevent
    #                                       from running in parallel with other tests. Defaults to false.
    # @param [EXECUTOR <path>]              Path to the "test executor". Defaults to RSP_TEST_EXECUTOR_PATH,
    #                                       when not specified.
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
        set(oneValueArgs NAME CALLBACK TEST_CASE BEFORE_CALLBACK AFTER_CALLBACK EXPECT_FAILURE SKIP RUN_SERIAL EXECUTOR)
        set(multiValueArgs LABELS CALLBACK_ARG) # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
        requires_arguments(INPUT "NAME;CALLBACK;TEST_CASE")

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

        set(enforce_serial_run false)
        if (DEFINED INPUT_RUN_SERIAL)
            set(enforce_serial_run "${INPUT_RUN_SERIAL}")
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
        #        if (NOT EXISTS "${INPUT_EXECUTOR}")
        #            message(FATAL_ERROR "Path to \"test executor\" is invalid: ${INPUT_EXECUTOR}")
        #        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Escape lists (semicolon), so they can be passed as arguments for cmake command line.
        string(REPLACE ";" "\\;" module_paths "${CMAKE_MODULE_PATH}")
        string(REPLACE ";" "\\;" callback_args "${INPUT_CALLBACK_ARG}")

        # ---------------------------------------------------------------------------------------------- #

        # Debug
        message(VERBOSE "\tAdding test: ${INPUT_NAME}")

        # Add the actual CTest, using CMake's executable to process a script file...
        add_test(
            NAME "${INPUT_NAME}"
            COMMAND ${CMAKE_COMMAND}
                -D TEST_NAME:STRING=${INPUT_NAME}
                -D TEST_CALLBACK:STRING=${INPUT_CALLBACK}
                -D TEST_CASE:PATH=${INPUT_TEST_CASE}
                -D CALLBACK_ARG:STRING=${callback_args}
                -D BEFORE_CALLBACK:STRING=${INPUT_BEFORE_CALLBACK}
                -D AFTER_CALLBACK:STRING=${INPUT_AFTER_CALLBACK}
                -D MODULE_PATHS:STRING=${module_paths}
                -P "${INPUT_EXECUTOR}"
        )

        # Set test failure expectation
        # @see https://cmake.org/cmake/help/latest/prop_test/WILL_FAIL.html#prop_test:WILL_FAIL
        set_property(TEST ${INPUT_NAME} PROPERTY WILL_FAIL "${INPUT_EXPECT_FAILURE}")

        # Skip test if needed
        # @see https://cmake.org/cmake/help/latest/prop_test/DISABLED.html
        set_property(TEST ${INPUT_NAME} PROPERTY DISABLED "${INPUT_SKIP}")

        # Enforce "run serial", if needed
        # @see https://cmake.org/cmake/help/latest/prop_test/RUN_SERIAL.html
        set_property(TEST ${INPUT_NAME} PROPERTY RUN_SERIAL "${enforce_serial_run}")

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

        # Test-case label (disabled - results in too many redundant labels...)
        #        cache_has(KEY _RSP_CURRENT_TEST_CASE OUTPUT has_test_case)
        #        if (has_test_case)
        #            cache_get(KEY _RSP_CURRENT_TEST_CASE)
        #            list(APPEND labels_list "${_RSP_CURRENT_TEST_CASE}")
        #        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Test-case defined labels
        cache_has(KEY _RSP_CURRENT_TEST_CASE_LABELS OUTPUT has_test_case_labels)
        if (has_test_case_labels)
            cache_get(KEY _RSP_CURRENT_TEST_CASE_LABELS)

            # Ensure cached value is converted to list
            string(REPLACE "|" ";" cached_labels_list "${_RSP_CURRENT_TEST_CASE_LABELS}")

            list(APPEND labels_list "${cached_labels_list}")
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