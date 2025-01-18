# -------------------------------------------------------------------------------------------------------------- #
# RSP CMake Scripts - Tests
# -------------------------------------------------------------------------------------------------------------- #

enable_testing()

project(rsp-cmake-scripts-tests LANGUAGES NONE)

message(STATUS "Building ${PROJECT_NAME}")

# TODO: ... describe why we do this!?

# Find all tests
file(GLOB_RECURSE UNIT_TESTS "${CMAKE_CURRENT_SOURCE_DIR}/unit/*.cmake")


# TODO: SHOULD BE WRAPPED INTO A FUNCTION, IN THE "testing.cmake" module
foreach (testFile ${UNIT_TESTS})
    message(STATUS "Adding tests from: ${testFile}")

    # Include the given file, to define the tests (callbacks to be invoked)
    include("${testFile}")

    # Debug
    #dump(DEFINED_TESTS_LIST)

    # Add each defined test using ctest's add_test
    foreach (entry ${DEFINED_TESTS_LIST})
        extract_test_entry(
            ENTRY "${entry}"
            NAME name
            CALLBACK callback
        )

        # Debug
        message("\t\t${name} ${callback}")

        # TODO: This can perhaps be checked elsewhere...
        # Fail if path to test executor is invalid
        if (NOT EXISTS "${RSP_TEST_EXECUTOR_PATH}")
            message(FATAL_ERROR "Path to \"test executor\" is invalid: ${RSP_TEST_EXECUTOR_PATH}")
        endif ()

        # Add CTest, use custom executor
        add_test(
            NAME "${name}"
            COMMAND ${CMAKE_COMMAND}
                -DTEST_NAME=${name}
                -DTEST_CALLBACK=${callback}
                -DTEST_FILE=${testFile}
                -DMODULE_PATHS=${CMAKE_MODULE_PATH}
                -P "${RSP_TEST_EXECUTOR_PATH}"
        )

        # TODO: Add WILL_FAIL, based on entry!
        # TODO: @see https://cmake.org/cmake/help/latest/prop_test/WILL_FAIL.html#prop_test:WILL_FAIL

        # TODO: What about test LABELS
        # TODO: @see https://stackoverflow.com/questions/24495412/ctest-using-labels-for-different-tests-ctesttestfile-cmake

        # Remove the test entry from list
        list(POP_FRONT DEFINED_TESTS_LIST)
    endforeach ()
endforeach ()


# TODO: This adds the test file... but then each test will have to be in a file by itself to be "clean"
#foreach (testFile ${UNIT_TESTS})
#    message(STATUS "Adding test: ${testFile}")
#
#    add_test(
#        NAME ${testFile}
#        COMMAND ${CMAKE_COMMAND} -P "${testFile}"
#    )
#endforeach ()

# TODO: Run the following from the root:
# TODO:     ctest --output-on-failure --test-dir build/tests
# TODO:     ctest --rerun-failed --verbose --test-dir build/tests