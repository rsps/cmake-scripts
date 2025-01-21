include("rsp/testing")
include("rsp/cache")

define_test_case(
    "Cache Test"
    LABELS "cache"
)

# -------------------------------------------------------------------------------------------------------------- #
# IMPORTANT:
# -------------------------------------------------------------------------------------------------------------- #
#
# These defined tests are NOT actually writing to cmake's cache. Tests are not executed within a project
# scope, meaning that the `set(... CACHE)` is not going to work as intended. These tests are more "mock"-like,
# or in-memory tests, rather than real read/write tests.
# @see https://cmake.org/cmake/help/latest/command/set.html#set-cache-entry
#

# -------------------------------------------------------------------------------------------------------------- #
# Actual tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("can set and get entry" "can_set_get_entry")
function(can_set_get_entry)
    set(value "bar")

    cache_set(KEY foo VALUE "${value}")
    cache_has(KEY foo OUTPUT exists)

    assert_truthy(exists MESSAGE "Entry does not appear to exist in cache")

    cache_get(KEY foo DEFAULT "unknown")
    assert_string_equals("${value}" "${foo}" MESSAGE "Incorrect retrieved cache entry value")
endfunction()

define_test("can determine if entry has expired" "can_determine_if_expired")
function(can_determine_if_expired)
    set(value "bar")

    cache_set(KEY foo VALUE "foo" TTL 1)
    cache_has_expired(KEY foo OUTPUT has_expired)
    assert_falsy(has_expired MESSAGE "Entry should not have expired")

    # Force (re)set the entry TTL to -1 seconds. It should still
    # be declared as a valid entry with expiration timestamp set.
    cache_set(KEY foo VALUE "foo" TTL -1)

    # Force x-seconds sleep.
    #    set(seconds 1)
    #    message(STATUS "Sleep for ${seconds} second...")
    #    execute_process(COMMAND ${CMAKE_COMMAND} -E sleep ${seconds})

    cache_has_expired(KEY foo OUTPUT has_expired)
    assert_truthy(has_expired MESSAGE "Entry should have expired")
endfunction()

define_test("returns default when no entry" "returns_default_when_no_entry")
function(returns_default_when_no_entry)
    set(default_value "zim")

    cache_get(KEY foo DEFAULT "${default_value}")

    assert_string_equals("${default_value}" "${foo}" MESSAGE "Incorrect default value")
endfunction()

define_test("can forget entry" "can_forget_entry")
function(can_forget_entry)
    set(value "bar")

    cache_set(KEY foo VALUE "bar")
    cache_forget(KEY foo)

    cache_has(KEY foo OUTPUT exists)

    assert_falsy(exists MESSAGE "Entry was not deleted")
endfunction()

define_test("can remember" "invokes_callback_for_remember")
function(invokes_callback_for_remember)

    function(my_callback output)
        set("${output}" "lipsum")
        return(PROPAGATE "${output}")
    endfunction()
    cache_remember(KEY foo CALLBACK "my_callback")

    assert_string_equals("lipsum" "${foo}" MESSAGE "Incorrect value obtained via remember 1st call")

    # ---------------------------------------------------------------------------- #

    # Attempt to obtain via get
    cache_get(KEY "foo" DEFAULT "n/a")
    assert_string_equals("lipsum" "${foo}" MESSAGE "Incorrect value obtained via remember 2nd call")
endfunction()