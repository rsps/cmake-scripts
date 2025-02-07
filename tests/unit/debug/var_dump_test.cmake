include("rsp/testing")
include("rsp/debug")

define_test_case(
    "Var Dump Test"
    LABELS "debug;var_dump;dump"
)

# -------------------------------------------------------------------------------------------------------------- #
# Actual tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("dumps 'undefined' when is not declared" "dumps_undefined")
function(dumps_undefined)

    var_dump(OUTPUT result PROPERTIES foo)

    string(STRIP "${result}" result)
    assert_string_equals("foo = (undefined)" "${result}" MESSAGE "Incorrect dump")
endfunction()

define_test("can dump without property name" "dumps_without_prop_name")
function(dumps_without_prop_name)

    var_dump(OUTPUT result WITHOUT_NAMES PROPERTIES foo)

    string(STRIP "${result}" result)
    assert_string_equals("(undefined)" "${result}" MESSAGE "Incorrect dump")
endfunction()

define_test("can dump string with length" "can_dump_str_width_length")
function(can_dump_str_width_length)

    set(prop "foo")
    var_dump(OUTPUT result WITHOUT_NAMES PROPERTIES prop)

    string(STRIP "${result}" result)
    assert_string_equals("(string 3) \"${prop}\"" "${result}" MESSAGE "Incorrect dump of string")
endfunction()

define_test("can dump empty string" "can_dump_empty_str")
function(can_dump_empty_str)

    set(prop "")
    var_dump(OUTPUT result WITHOUT_NAMES PROPERTIES prop)

    string(STRIP "${result}" result)
    assert_string_equals("(string 0) \"\"" "${result}" MESSAGE "Incorrect dump of empty string")
endfunction()

define_test("can dump integer" "can_dump_int")
function(can_dump_int)

    set(prop 42)
    var_dump(OUTPUT result WITHOUT_NAMES PROPERTIES prop)

    string(STRIP "${result}" result)
    assert_string_equals("(int) ${prop}" "${result}" MESSAGE "Incorrect dump of integer")
endfunction()

define_test("can dump float" "can_dump_float")
function(can_dump_float)

    set(prop 42.1234)
    var_dump(OUTPUT result WITHOUT_NAMES PROPERTIES prop)

    string(STRIP "${result}" result)
    assert_string_equals("(float) ${prop}" "${result}" MESSAGE "Incorrect dump of float")
endfunction()

define_test("can dump boolean" "can_dump_bool")
function(can_dump_bool)

    set(prop false)
    var_dump(OUTPUT result WITHOUT_NAMES PROPERTIES prop)

    string(STRIP "${result}" result)
    assert_string_equals("(bool) ${prop}" "${result}" MESSAGE "Incorrect dump of boolean")
endfunction()

define_test("can dump list" "can_dump_list")
function(can_dump_list)

    set(prop "a;12;true")
    var_dump(OUTPUT result WITHOUT_NAMES PROPERTIES prop)

    string(STRIP "${result}" result)

    # Debug
    # message("${result}")

    assert_string_contains("${result}" "0: (string 1) \"a\"" MESSAGE "Incorrect list item")
    assert_string_contains("${result}" "1: (int) 12" MESSAGE "Incorrect list item")
    assert_string_contains("${result}" "2: (bool) true" MESSAGE "Incorrect list item")
endfunction()

define_test("can ignore list" "can_ignore_list")
function(can_ignore_list)

    set(prop "a;12;true")
    var_dump(OUTPUT result WITHOUT_NAMES IGNORE_LIST PROPERTIES prop)

    string(STRIP "${result}" result)

    # Debug
    # message("${result}")

    assert_string_contains("${result}" "(string 9) \"${prop}\"" MESSAGE "Incorrect dump of list (as string)")
endfunction()

define_test("does not attempt to dump 'nested' list" "does_not_dump_as_nested_list")
function(does_not_dump_as_nested_list)

    # A different list...
    set(other_list "foo;bar")

    # In this list, a value corresponds to the "other_list" property, which
    # is a bit unlucky. Nevertheless, the var_dump SHOULD not attempt to treat
    # it as a "nested" list. Instead, it should see this a string value...
    set(prop "a;12;true;other_list")
    var_dump(OUTPUT result WITHOUT_NAMES PROPERTIES prop)

    string(STRIP "${result}" result)

    # Debug
    # message("${result}")

    assert_string_contains("${result}" "0: (string 1) \"a\"" MESSAGE "Incorrect list item")
    assert_string_contains("${result}" "1: (int) 12" MESSAGE "Incorrect list item")
    assert_string_contains("${result}" "2: (bool) true" MESSAGE "Incorrect list item")
    assert_string_contains("${result}" "3: (string 10) \"other_list\"" MESSAGE "Incorrect list item")
endfunction()

define_test("can dump command" "can_dump_cmd")
function(can_dump_cmd)

    macro(my_macro)
    endmacro()

    function(my_function)
    endfunction()

    var_dump(OUTPUT result WITHOUT_NAMES PROPERTIES my_macro my_function)

    string(STRIP "${result}" result)

    assert_string_contains("${result}" "(command) my_macro()" MESSAGE "Incorrect dump of command (macro)")
    assert_string_contains("${result}" "(command) my_function()" MESSAGE "Incorrect dump of command (function)")
endfunction()

define_test("shows if variable is cached" "dump_shows_if_prop_cached")
function(dump_shows_if_prop_cached)

    set(rsp_test_prop "foo" CACHE STRING "For testing only")
    var_dump(OUTPUT result WITHOUT_NAMES PROPERTIES rsp_test_prop)

    string(STRIP "${result}" result)
    assert_string_equals("(string 3, cached) \"${rsp_test_prop}\"" "${result}" MESSAGE "Incorrect dump of cached state")

    unset(rsp_test_prop CACHE)
endfunction()

define_test("shows if environment variable" "dump_shows_if_env_prop")
function(dump_shows_if_env_prop)

    set(ENV{rsp_test_env_prop} "/lorum/lipsum")
    var_dump(OUTPUT result WITHOUT_NAMES PROPERTIES rsp_test_env_prop)

    string(STRIP "${result}" result)
    assert_string_equals("(string 13, ENV) \"$ENV{rsp_test_env_prop}\"" "${result}" MESSAGE "Incorrect dump of env state")

    unset(ENV{rsp_test_env_prop})
endfunction()