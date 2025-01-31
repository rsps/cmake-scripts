include("rsp/testing")
include("rsp/output")

define_test_case(
    "Output Test"
    LABELS "output"
)

# -------------------------------------------------------------------------------------------------------------- #
# Actual tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("can output string" "can_output_str_msg")
function(can_output_str_msg)

    output("foo" OUTPUT result)

    assert_string_equals("foo" "${result}" MESSAGE "Incorrect output")
endfunction()

define_test("can output variable value" "can_output_var_value_msg")
function(can_output_var_value_msg)

    set(foo "bar")
    output(foo OUTPUT result)

    assert_string_equals("${foo}" "${result}" MESSAGE "Incorrect output")
endfunction()

define_test("can output list" "can_output_list_msg")
function(can_output_list_msg)

    set(my_list "a;b;c")
    output(my_list OUTPUT result LIST_SEPARATOR ", ")

    set(expected "a, b, c")

    assert_string_equals("${expected}" "${result}" MESSAGE "Incorrect output")
endfunction()

define_test("can output with label" "can_output_with_label_msg")
function(can_output_with_label_msg)

    set(msg "Hi there")
    set(label "INFO: ")
    set(label_format "%label%") # Keep format simple for test...

    output(msg
        OUTPUT result
        LABEL "${label}"
        LABEL_FORMAT "${label_format}"
    )

    set(expected "${label}${msg}")

    assert_string_equals("${expected}" "${result}" MESSAGE "Incorrect output")
endfunction()

define_test("applies cmake message mode" "applies_cmake_msg_mode" EXPECT_FAILURE)
function(applies_cmake_msg_mode)

    # CMake's FATAL_ERROR message mode requested, meaning that test
    # MUST be expected to fail...
    output("foo" FATAL_ERROR)
endfunction()