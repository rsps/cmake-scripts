include("rsp/testing")

# -------------------------------------------------------------------------------------------------------------- #
# Tests for "Truthy / Falsy" assertions
# -------------------------------------------------------------------------------------------------------------- #

define_test("can assert truthy keys" "asserts_truthy_keys")
function(asserts_truthy_keys)
    set(a TRUE)
    assert_truthy(a MESSAGE "const 'TRUE'")

    set(b 1)
    assert_truthy(b MESSAGE "number")

    set(c 3.2)
    assert_truthy(c MESSAGE "float")

    set(d ON)
    assert_truthy(d MESSAGE "const 'ON'")

    set(e YES)
    assert_truthy(e MESSAGE "const 'YES'")

    set(f Y)
    assert_truthy(f MESSAGE "const 'Y'")
endfunction()

define_test("can assert truthy values" "asserts_truthy_values")
function(asserts_truthy_values)
    assert_truthy(TRUE MESSAGE "const 'TRUE'")

    assert_truthy(1 MESSAGE "number")

    assert_truthy(3.2 MESSAGE "float")

    assert_truthy(ON MESSAGE "const 'ON'")

    assert_truthy(YES MESSAGE "const 'YES'")

    assert_truthy(Y MESSAGE "const 'Y'")
endfunction()


define_test("can assert falsy keys" "asserts_falsy_keys")
function(asserts_falsy_keys)
    set(a FALSE)
    assert_falsy(a MESSAGE "const 'TRUE'")

    set(b 0)
    assert_falsy(b MESSAGE "number")

    set(c OFF)
    assert_falsy(c MESSAGE "const 'OFF'")

    set(d NO)
    assert_falsy(d MESSAGE "const 'NO'")

    set(e N)
    assert_falsy(e MESSAGE "const 'N'")

    set(f IGNORE)
    assert_falsy(f MESSAGE "const 'IGNORE'")

    set(g NOTFOUND)
    assert_falsy(g MESSAGE "const 'NOTFOUND'")

    set(h "")
    assert_falsy(h MESSAGE "empty string")

    set(i "abc-NOTFOUND")
    assert_falsy(i MESSAGE "string that end with '-NOTFOUND'")
endfunction()

define_test("can assert falsy values" "asserts_falsy_values")
function(asserts_falsy_values)
    assert_falsy(FALSE MESSAGE "const 'TRUE'")

    assert_falsy(0 MESSAGE "number")

    assert_falsy(OFF MESSAGE "const 'OFF'")

    assert_falsy(NO MESSAGE "const 'NO'")

    assert_falsy(N MESSAGE "const 'N'")

    assert_falsy(IGNORE MESSAGE "const 'IGNORE'")

    assert_falsy(NOTFOUND MESSAGE "const 'NOTFOUND'")

    assert_falsy("" MESSAGE "empty string")

    assert_falsy("abc-NOTFOUND" MESSAGE "string that end with '-NOTFOUND'")
endfunction()

# -------------------------------------------------------------------------------------------------------------- #
# Existence
# -------------------------------------------------------------------------------------------------------------- #

define_test("can assert defined keys" "asserts_defined_keys")
function(asserts_defined_keys)
    set(foo "")

    assert_defined(foo)
endfunction()

define_test("can assert not defined keys" "asserts_not_defined_keys")
function(asserts_not_defined_keys)
    assert_not_defined(foo)
endfunction()

define_test("can assert callable" "asserts_callable")
function(asserts_callable)
    function(foo)
    endfunction()

    macro(bar)
    endmacro()

    assert_is_callable(foo MESSAGE "function")
    assert_is_callable(bar MESSAGE "marco")
endfunction()

define_test("can assert not callable" "asserts_not_callable")
function(asserts_not_callable)
    assert_is_not_callable(none MESSAGE "none defined")

    set(foo "bar")
    assert_is_not_callable(foo MESSAGE "variable")
endfunction()