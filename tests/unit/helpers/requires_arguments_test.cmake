include("rsp/testing")
include("rsp/helpers")

define_test_case(
    "Requires Arguments Test"
    LABELS "requires;args;helpers"
)

# -------------------------------------------------------------------------------------------------------------- #
# Helpers
# -------------------------------------------------------------------------------------------------------------- #

function(fn_with_required_args)
    set(options "") # N/A
    set(oneValueArgs NAME DESCRIPTION)
    set(multiValueArgs "") # N/A

    cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    requires_arguments(INPUT "NAME;DESCRIPTION")
endfunction()

# -------------------------------------------------------------------------------------------------------------- #
# Actual Tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("ensures required args are defined" "ensures_required_args_defined")
function(ensures_required_args_defined)

    # If invoking method does not cause a fatal error, test passes.
    fn_with_required_args(NAME "foo" DESCRIPTION "bar")

endfunction()

define_test("fails when required args are not defined" "fails_when_required_arg_not_defined" EXPECT_FAILURE)
function(fails_when_required_arg_not_defined)

    # This should cause a failure because DESCRIPTION is required
    fn_with_required_args(NAME "foo")

endfunction()