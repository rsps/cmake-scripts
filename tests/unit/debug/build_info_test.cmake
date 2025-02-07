include("rsp/testing")
include("rsp/debug")

define_test_case(
        "Build Info Test"
        LABELS "debug;build_info"
)

# -------------------------------------------------------------------------------------------------------------- #
# Actual Tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("can output build info" "outputs_build_info")
function(outputs_build_info)

    # Set a few of the build info variables
    set(CMAKE_BUILD_TYPE "Debug")
    set(LIB_TYPE "STATIC")

    # ---------------------------------------------------------------------- #

    build_info(OUTPUT result)

    # Debug
    # message("${result}")

    # ---------------------------------------------------------------------- #

    # Ensure that a few of the properties are in the output
    assert_string_contains("${result}" "Type: ${CMAKE_BUILD_TYPE}" MESSAGE "Incorrect build info output (build type)")
    assert_string_contains("${result}" "Library Type: ${LIB_TYPE}" MESSAGE "Incorrect build info output (library type)")
endfunction()
