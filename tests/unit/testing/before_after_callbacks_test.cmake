include("rsp/testing")
include("rsp/helpers")
include("rsp/cache")

define_test_case(
    "Before / After Callback Test"
    LABELS "before;after;callback;testing"

    BEFORE "before_macro"
    AFTER "after_function"
)

macro(before_macro)
    # This variable will be made available for the next
    # test that is executed...
    set(before_callback_invoked true PARENT_SCOPE)
endmacro()

function(after_function)
    # NOTE: Variables are NOT persisted between test executions.
    # So we cannot assert that this "after" callback in the
    # same way as the "before" callback.
    # set(after_callback_invoked true PARENT_SCOPE)

    # Create a temporary file, persisted between process executions.
    file(TOUCH "${CMAKE_CURRENT_SOURCE_DIR}/Testing/Temporary/rsp_after_test_callback.tmp")

    # Hacky, but does work...
    # assert_truthy(true MESSAGE "after callback was not invoked")
endfunction()

# -------------------------------------------------------------------------------------------------------------- #
# Actual tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("has invoked before callback" "has_invoked_before")
function(has_invoked_before)
    assert_truthy(before_callback_invoked MESSAGE "Before callback not invoked")
endfunction()

define_test("has invoked after callback" "has_invoked_after")
function(has_invoked_after)
    # Debug
    # execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 2.5)

    # If a previous test was executed, then the "after" callback for
    # this test-case should have been invoked. This means that a tmp file
    # should had been created.
    set(tmp_file "${CMAKE_CURRENT_SOURCE_DIR}/Testing/Temporary/rsp_after_test_callback.tmp")
    assert_file_exists("${tmp_file}" MESSAGE "After callback not invoked, no tmp file created")

    # Determine if the file's timestamp was recently updated.
    string(TIMESTAMP now "%s")
    file(TIMESTAMP "${tmp_file}" timestamp "%s")
    math(EXPR diff "${now} - ${timestamp}")

    # If the difference of the timestamps isn't significant, test passes
    # (Depending on the testing environment, there could be 1-2 seconds difference)
    assert_less_than_or_equal(2 diff MESSAGE "After callback not invoked")
endfunction()