include("rsp/testing")
include("rsp/helpers")

define_test_case(
    "Requires Arguments Test"
    LABELS "requires;args;helpers"
)

# -------------------------------------------------------------------------------------------------------------- #
# Helpers
# -------------------------------------------------------------------------------------------------------------- #

function(fn_with_named_args)
    set(options "") # N/A
    set(oneValueArgs NAME DESCRIPTION)
    set(multiValueArgs "") # N/A

    cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    requires_arguments("NAME;DESCRIPTION" INPUT)
endfunction()

function(fn_with_args name)
    if (${ARGC} EQUAL 2)
        set(description "${ARGV1}")
    endif ()

    # This may seem a bit strange to declare "description" as required
    # here, however, this is fully intended (for the test...)
    requires_arguments("name;description" "")
endfunction()

# -------------------------------------------------------------------------------------------------------------- #
# Actual Tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("ensures required named args are defined" "ensures_required_named_args_defined")
function(ensures_required_named_args_defined)

    # If invoking method does not cause a fatal error, test passes.
    fn_with_named_args(NAME "foo" DESCRIPTION "bar")

endfunction()

define_test("ensures required args are defined" "ensures_required_args_defined")
function(ensures_required_args_defined)

    # If invoking method does not cause a fatal error, test passes.
    fn_with_args("foo" "bar")

endfunction()

define_test("fails when required named args are not defined" "fails_when_required_named_arg_not_defined" EXPECT_FAILURE)
function(fails_when_required_named_arg_not_defined)

    # This should cause a failure because DESCRIPTION is required
    fn_with_named_args(NAME "foo")

endfunction()

define_test("fails when required args are not defined" "fails_when_required_arg_not_defined" EXPECT_FAILURE)
function(fails_when_required_arg_not_defined)

    # This should cause a failure because second argument is required
    fn_with_args("foo")

endfunction()