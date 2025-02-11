include("rsp/testing")
include("rsp/helpers")
include("rsp/debug")

define_test_case(
    "Safeguard Properties Test"
    LABELS "properties;helpers"
)

define_test("can restore properties if changed" "can_safeguard_properties")
function(can_safeguard_properties)
    set(a "aaa")
    set(b "bbb")
    set(c "ccc")

    function(risky_callback)
        message(VERBOSE "risky callback invoked (function)")

        set(a "1" PARENT_SCOPE)
        set(b "2" PARENT_SCOPE)
        set(c "3" PARENT_SCOPE)
    endfunction()

    safeguard_properties("risky_callback" "a;b;c")

    # Debug
    #risky_callback()

    assert_string_equals("aaa" ${a} MESSAGE "Property a was modified")
    assert_string_equals("bbb" ${b} MESSAGE "Property b was modified")
    assert_string_equals("ccc" ${c} MESSAGE "Property c was modified")
endfunction()

define_test("unguarded properties can be changed" "unguarded_properties_can_be_changed")
function(unguarded_properties_can_be_changed)
    set(a "aaa")
    set(b "bbb")
    set(c "ccc")

    macro(risky_callback)
        message(NOTICE "risky callback invoked (macro)")

        set(a "1")
        set(b "2")
        set(c "3")
    endmacro()

    # Note: "c" is NOT safeguarded here
    safeguard_properties("risky_callback" "a;b")

    # Debug
    #risky_callback()

    assert_string_equals("aaa" ${a} MESSAGE "Property a was modified")
    assert_string_equals("bbb" ${b} MESSAGE "Property b was modified")
    assert_string_equals("3" ${c} MESSAGE "Property c SHOULD had been modified")
endfunction()
