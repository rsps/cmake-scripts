include("${RSP_MODULE_PATH}/rsp/testing.cmake")

# TODO: ...a test file..

# message(STATUS "Test Passed")
# message(FATAL_ERROR "Test Failure")

define_test("A - 1st test" "test_hi_there")
function(test_hi_there)
    message(STATUS "${CMAKE_CURRENT_FUNCTION} test success")
endfunction()

define_test("B - 2nd test" "test_something_complete")
function(test_something_complete)
    message(STATUS "${CMAKE_CURRENT_FUNCTION} test success")
endfunction()

define_test("C - 3rd test" "test_that_fails")
function(test_that_fails)
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} test failure")
endfunction()

define_test("D - 4th test" "last_demo_test")
function(last_demo_test)
    message(STATUS "${CMAKE_CURRENT_FUNCTION} test success")
endfunction()