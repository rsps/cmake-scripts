include("rsp/testing")
include("rsp/compilers/gcc")
include("rsp/debug")

define_test_case(
    "GCC Info Test"
    LABELS "gcc;version;compilers"
)

# -------------------------------------------------------------------------------------------------------------- #
# Actual tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("can obtain GCC path and version" "can_obtain_gcc_info")
function(can_obtain_gcc_info)

    gcc_info(OUTPUT result)

    assert_string_not_empty("${result}" MESSAGE "GCC path not obtained")

    assert_defined("result_VERSION" MESSAGE "GCC Version not defined")
    assert_string_not_empty("${result_VERSION}" MESSAGE "GCC path not obtained")
endfunction()
