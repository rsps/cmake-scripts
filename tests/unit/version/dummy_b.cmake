include("${RSP_MODULE_PATH}/rsp/testing.cmake")

# TODO: ...a test file..

# message(STATUS "Test Passed")
# message(FATAL_ERROR "Test Failure")

define_test("X - my cool test" "aaa")
function(aaa)
    message(STATUS "${CMAKE_CURRENT_FUNCTION} test success")
endfunction()

define_test("Y - my last cool test" "bbb")
function(bbb)
    message(STATUS "${CMAKE_CURRENT_FUNCTION} test success")
endfunction()