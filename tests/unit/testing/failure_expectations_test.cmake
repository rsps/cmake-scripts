include("rsp/testing")

define_test_case(
    "Failure Expectations Test"
    LABELS "failure;expectations;testing"
)

define_test("test without failure expectation" "no_fail_exp_test")
function(no_fail_exp_test)
    assert_truthy(true)
endfunction()

define_test("test with failure expectation" "expected_failure_test" EXPECT_FAILURE)
function(expected_failure_test)
    # This should cause test to fail - but the EXPECT_FAILURE
    # will force ctest to mark the test as a success!
    assert_truthy(false)
endfunction()

# Disabled this test...
#define_test("test that expects failure" "should_fail_test" EXPECT_FAILURE)
#function(should_fail_test)
#    # Here, the test does not fail, but ctest is instructed to expect
#    # the test to fail. So, it will be marked as failed.
#    assert_truthy(true)
#endfunction()