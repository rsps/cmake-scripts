include("rsp/testing")
include("rsp/compilers/gcc")

define_test_case(
    "GCC Version Test"
    LABELS "gcc;version;compilers"
)

# -------------------------------------------------------------------------------------------------------------- #
# Actual tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("can obtain GCC version" "can_obtain_gcc_version")
function(can_obtain_gcc_version)

    gcc_version(OUTPUT version)

    assert_string_not_empty("${version}" MESSAGE "GCC version not obtained")
endfunction()
