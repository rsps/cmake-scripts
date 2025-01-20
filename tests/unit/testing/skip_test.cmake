include("rsp/testing")

define_test_case(
    "Skip Test"
    LABELS "skip;disable;testing"
)

define_test("can skip test" "skip_test" SKIP)
function(skip_test)
    # This assert should never be reached.
    assert_truthy(false MESSAGE "Skipped was executed!")
endfunction()