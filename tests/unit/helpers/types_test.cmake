include("rsp/testing")
include("rsp/helpers")

define_test_case(
    "Types Test"
    LABELS "types;helpers"
)

# -------------------------------------------------------------------------------------------------------------- #
# Data Providers
# -------------------------------------------------------------------------------------------------------------- #

function(provides_values output)
    # Format:
    # <value> | <expected type>
    # <value>[@<value>] | <expected type> - list
    set("${output}"
        "foo|string"
        "|string"
        "?|string"
        "0|int"
        "-2|int"
        "0.1|float"
        "-0.1|float"
        "true|bool"
        "false|bool"
        "a@b@c|list" # "@" must be replaced with ";" in test!
        "define_test_case|command"
        "define_test|command"
    )
    return (PROPAGATE "${output}")
endfunction()

# -------------------------------------------------------------------------------------------------------------- #
# Actual tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("can determine if integer" "can_determine_if_int")
function(can_determine_if_int)

    is_int(22 a)
    assert_truthy(a MESSAGE "a should be an int")

    is_int(0 b)
    assert_truthy(b MESSAGE "b should be an int")

    set(value 8)
    is_int(value c)
    assert_truthy(c MESSAGE "c should be an int")

    set(value -8)
    is_int(value d)
    assert_truthy(d MESSAGE "d should be an int")

    is_int(2.34 e)
    assert_falsy(e MESSAGE "e should NOT be an int")

    set(value 1.123)
    is_int(value f)
    assert_falsy(f MESSAGE "f should NOT be an int")

    is_int("str" g)
    assert_falsy(g MESSAGE "g should NOT be an int")

    is_int(true h)
    assert_falsy(h MESSAGE "h should NOT be an int")

    is_int(false i)
    assert_falsy(i MESSAGE "i should NOT be an int")

    set(my_list "foo;bar;zim")
    is_int(my_list j)
    assert_falsy(j MESSAGE "j should NOT be an int")
endfunction()

define_test("can determine if float" "can_determine_if_float")
function(can_determine_if_float)

    is_float(22 a)
    assert_falsy(a MESSAGE "a should NOT be a float")

    set(value 8)
    is_float(value b)
    assert_falsy(b MESSAGE "b should NOT be a float")

    is_float(2.34 c)
    assert_truthy(c MESSAGE "c should be a float")

    set(value 1.123)
    is_float(value d)
    assert_truthy(d MESSAGE "d should be a float")

    is_float("str" e)
    assert_falsy(e MESSAGE "e should NOT be a float")

    is_float(true f)
    assert_falsy(f MESSAGE "f should NOT be a float")

    is_float(false g)
    assert_falsy(g MESSAGE "g should NOT be a float")

    set(my_list "foo;bar;zim")
    is_float(my_list h)
    assert_falsy(h MESSAGE "g should NOT be a float")

    set(value -1.02)
    is_float(value i)
    assert_truthy(i MESSAGE "i should be a float")
endfunction()

define_test("can determine if numeric" "can_determine_if_numeric")
function(can_determine_if_numeric)

    is_numeric(22 a)
    assert_truthy(a MESSAGE "a should be numeric")

    set(value 8)
    is_numeric(value b)
    assert_truthy(b MESSAGE "b should be numeric")

    is_numeric(2.34 c)
    assert_truthy(c MESSAGE "c should be numeric")

    set(value 1.123)
    is_numeric(value d)
    assert_truthy(d MESSAGE "d should be numeric")

    is_numeric("str" e)
    assert_falsy(e MESSAGE "e should NOT be numeric")

    is_numeric(true f)
    assert_falsy(f MESSAGE "f should NOT be numeric")

    is_numeric(false g)
    assert_falsy(g MESSAGE "g should NOT be numeric")

    set(my_list "foo;bar;zim")
    is_numeric(my_list h)
    assert_falsy(h MESSAGE "g should NOT be numeric")

    set(value -22.02)
    is_numeric(value i)
    assert_truthy(i MESSAGE "i should be numeric")
endfunction()

define_test("can determine if boolean" "can_determine_if_bool")
function(can_determine_if_bool)

    is_bool(22 a)
    assert_falsy(a MESSAGE "a should NOT be a bool")

    set(value 8)
    is_bool(value b)
    assert_falsy(b MESSAGE "b should NOT be a bool")

    is_bool(2.34 c)
    assert_falsy(c MESSAGE "c should NOT be a bool")

    set(value 1.123)
    is_bool(value d)
    assert_falsy(d MESSAGE "d should NOT be a bool")

    is_bool("str" e)
    assert_falsy(e MESSAGE "e should NOT be a bool")

    is_bool(true f)
    assert_truthy(f MESSAGE "f should be a bool")

    is_bool(false g)
    assert_truthy(g MESSAGE "g should be a bool")

    set(my_list "foo;bar;zim")
    is_bool(my_list h)
    assert_falsy(h MESSAGE "g should NOT be a bool")
endfunction()

define_test("can determine if boolean like" "can_determine_if_bool_like")
function(can_determine_if_bool_like)

    set(valid "1;on;yes;true;y;0;off;no;false;n;ignore;notfound")
    foreach (v IN LISTS value)
        is_bool_like(v result)
        assert_truthy(result MESSAGE "${v} should be bool like")
    endforeach ()

    # ------------------------------------------------------------ #

    is_bool_like("" empty_str)
    assert_truthy(empty_str MESSAGE "empty string should be bool like")

    # ------------------------------------------------------------ #

    is_bool_like("foo-NOTFOUND" end_with_not_found)
    assert_truthy(end_with_not_found MESSAGE "string with '-NOTFOUND' should be bool like")

    # ------------------------------------------------------------ #

    is_bool_like(22 a)
    assert_truthy(a MESSAGE "a should be bool like")

    set(value 8)
    is_bool_like(value b)
    assert_truthy(b MESSAGE "b should be bool like")

    is_bool_like(2.34 c)
    assert_truthy(c MESSAGE "c should be bool like")

    set(value 1.123)
    is_bool_like(value d)
    assert_truthy(d MESSAGE "d should be bool like")

    # ------------------------------------------------------------ #

    is_bool_like("str" e)
    assert_falsy(e MESSAGE "e should NOT be bool like")

    set(my_list "foo;bar;zim")
    is_bool_like(my_list f)
    assert_falsy(h MESSAGE "f should NOT be bool like")

    # ------------------------------------------------------------ #

    # NOTE: Negative numbers DO NOT evaluate to false in cmake!
    set(my_negative_value "-1")
#    if (NOT my_negative_value)
#        message("Expected this to work...")
#    endif ()
    is_bool_like(my_negative_value g)
    assert_falsy(g MESSAGE "g should NOT be bool like")

endfunction()

define_test("can determine if list" "can_determine_if_list")
function(can_determine_if_list)

    set(list_a "aa;bbb;ccc")
    is_list(list_a a)
    assert_truthy(a MESSAGE "a should be a list")

    set(list_b aa bbb ccc)
    is_list(list_b b)
    assert_truthy(b MESSAGE "b should be a list")

    set(not_list "aa bbb ccc")
    is_list(not_list c)
    assert_falsy(c MESSAGE "c should NOT be a list")

    is_list("aa;bbb;ccc" d)
    assert_truthy(d MESSAGE "d should be a list")

    is_list("aa bbb ccc" e)
    assert_falsy(e MESSAGE "e should NOT be a list")

    is_list("foo" f)
    assert_falsy(f MESSAGE "f should NOT be a list")

    is_list(1 g)
    assert_falsy(g MESSAGE "g should NOT be a list")

    is_list(1.32 h)
    assert_falsy(h MESSAGE "h should NOT be a list")

    is_list(-1 i)
    assert_falsy(i MESSAGE "i should NOT be a list")

    is_list(false j)
    assert_falsy(j MESSAGE "j should NOT be a list")
endfunction()


define_test("can determine if command" "can_determine_if_cmd")
function(can_determine_if_cmd)

    macro(my_macro)
    endmacro()
    is_command(my_macro a)
    assert_truthy(a MESSAGE "a should be a command (macro)")

    function(my_function)
    endfunction()
    is_command(my_function b)
    assert_truthy(b MESSAGE "b should be a command (function)")

    # Not sure if this even can be tested...
    #    add_custom_command(TARGET my_command
    #        PRE_BUILD
    #        COMMAND ${CMAKE_COMMAND} -E echo hello
    #        COMMENT "FOR TESTING PURPOSES ONLY"
    #        VERBATIM
    #    )
    #    is_command(my_command c)
    #    assert_truthy(c MESSAGE "c should be a command (custom command)")

    set(my_var "")
    is_command(my_var d)
    assert_falsy(d MESSAGE "d should NOT be a command")

    set(fn_ref "my_function")
    is_command(fn_ref e)
    assert_truthy(e MESSAGE "e should be a command (reference)")

endfunction()

define_test("can determine if string" "can_determine_if_str")
function(can_determine_if_str)

    is_string("abc" a)
    assert_truthy(a MESSAGE "a should be a string")

    set(my_str "foo")
    is_string(my_str b)
    assert_truthy(b MESSAGE "b should be a string")

    set(my_empty_str "")
    is_string(my_empty_str c)
    assert_truthy(c MESSAGE "c should be a string")

    is_string(my_undefined_var d)
    assert_truthy(d MESSAGE "d should be a string")

    is_string(42 e)
    assert_falsy(e MESSAGE "e should NOT be a string")

    is_string(-42.1 f)
    assert_falsy(f MESSAGE "f should NOT be a string")

    set(list_a "a;b;c")
    is_string(list_a g)
    assert_falsy(g MESSAGE "g should NOT be a string")

    set(list_b aa bb cc)
    is_string(list_b h)
    assert_falsy(h MESSAGE "h should NOT be a string")

    set(not_list "aa bb cc")
    is_string(not_list i)
    assert_truthy(i MESSAGE "i should be a string")

    macro(my_macro)
    endmacro()
    is_string(my_macro j)
    assert_falsy(j MESSAGE "j should NOT be a string")

    function(my_function)
    endfunction()
    is_string(my_function k)
    assert_falsy(k MESSAGE "k should NOT be a string")

    set(fn_ref "my_function")
    is_string(fn_ref l)
    assert_falsy(l MESSAGE "l should NOT be a string")
endfunction()

define_test("can determine type" "can_determine_type" DATA_PROVIDER "provides_values")
function(can_determine_type item)

    string(REPLACE "|" ";" parts "${item}")
    list(GET parts 0 value)
    list(GET parts 1 expected)

    string(FIND "${value}" "@" is_sublist)
    if (NOT is_sublist EQUAL -1)
        string(REPLACE "@" ";" value "${value}")
    endif ()

    message("Value: ${value}")

    get_type(value result)
    assert_string_equals("${expected}" "${result}" MESSAGE "incorrect '${result}' type for value: ${value}")
endfunction()