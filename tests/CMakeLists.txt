# -------------------------------------------------------------------------------------------------------------- #
# RSP CMake Scripts - Tests
# -------------------------------------------------------------------------------------------------------------- #

enable_testing()

project(rsp-cmake-scripts-tests LANGUAGES NONE)

message(STATUS "Building ${PROJECT_NAME}")

# -------------------------------------------------------------------------------------------------------------- #

include("rsp/testing")

# Define the test suites for this project
define_test_suite("unit" DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/unit")

# HINT:
# Defined tests can be executed via the following:
#   ctest --output-on-failure --parallel --test-dir build/tests
#
# Or, if you only wish to run failed tests:
#   ctest --rerun-failed --verbose --test-dir build/tests
#
# To run only certain tests, e.g. you can query which label(s)
# you wish to run:
#   ctest --output-on-failure --label-regex "cache" --test-dir build/tests
