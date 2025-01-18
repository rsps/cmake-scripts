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

endforeach ()

# TODO: Run the following from the root:
# TODO:     ctest --output-on-failure --test-dir build/tests
# TODO:     ctest --rerun-failed --verbose --test-dir build/tests