include("rsp/testing")
include("rsp/helpers")

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
        set(a "1" PARENT_SCOPE)
        set(b "2" PARENT_SCOPE)
        set(c "3" PARENT_SCOPE)
    endfunction()

    safeguard_properties(
        CALLBACK "risky_callback"
        PROPERTIES
            a
            b
            c
    )

    # Debug
    #risky_callback()

    assert_string_equals("aaa" ${a} MESSAGE "Property a was modified")
    assert_string_equals("bbb" ${b} MESSAGE "Property a was modified")
    assert_string_equals("ccc" ${c} MESSAGE "Property a was modified")
endfunction()
