include("rsp/testing")

define_test("skips test" "skip_test" SKIP)
function(skip_test)
    # This assert should never be reached.
    assert_truthy(false MESSAGE "Skipped was executed!")
endfunction()