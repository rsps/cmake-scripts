include("rsp/testing")
include("rsp/debug")

# All tests are included via tests/CMakeLists.txt, using the define_test_suite().
# Yet, it seems that when "rsp/output" is included here, the RSP_ANSI_PRESET list
# either reset or simply not defined! The "include_guard(GLOBAL)" might not
# behave as desired! Therefore, we ONLY include "rsp/output" when executing tests!
if (_RSP_TEST_EXECUTOR_RUNNING)
    include("rsp/output")
endif ()

define_test_case(
    "ANSI Test"
    LABELS "ansi;output"

    AFTER "cleanup_ansi"

    #RUN_SERIAL
)

function(cleanup_ansi)
    disable_ansi()
endfunction()

# -------------------------------------------------------------------------------------------------------------- #
# Actual tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("ANSI is disabled by default" "ansi_disabled_by_default")
function(ansi_disabled_by_default)

    assert_defined(RSP_IS_ANSI_ENABLED MESSAGE "state variable not defined")
    assert_falsy(RSP_IS_ANSI_ENABLED MESSAGE "ANSI should NOT be enabled, by default")
endfunction()

define_test("can define ansi escape sequence" "can_define_ansi_escape_sequence")
function(can_define_ansi_escape_sequence)

    # NOTE: We need to replace the default escape char for this test, or we
    # cannot compare strings as desired.
    set(escape "e")


    #set(value "[1;31m")    # warning, semicolon causes issues for asserts (list form)
    #set(value "[31m")      # warning, the "[" seems to be parsed somehow by cmake,
                            # causing assert_compare_values() to interpret "expected"
                            # to contain a long string of all input vars!?
    set(value "31m")

    ansi_escape_sequence(OUTPUT sequence ESCAPE "${escape}" CODE "${value}")

    # Debug
    #dump(sequence)

    # Uh... well, this will have to do. A manual test can ensure that this works as
    # desired...
    assert_string_equals("${escape}${value}" "${sequence}" MESSAGE "Incorrect sequence defined")
endfunction()

define_test("can define ansi SGR" "can_define_ansi_sgr")
function(can_define_ansi_sgr)

    ansi_sgr(OUTPUT style CODE "1;31")

    # debug
    # string(REPLACE "${RSP_DEFAULT_ESCAPE_CHARACTER}[" "@" style "${style}")

    assert_string_not_empty("${style}" MESSAGE "SGR was not defined")
endfunction()

define_test("can enable ANSI (default preset)" "can_enable_ansi")
function(can_enable_ansi)

    enable_ansi()

    # Ensure that some of the predefined variables are defined, from default preset
    assert_defined(TEXT_BOLD)
    assert_defined(COLOR_RED)
    assert_defined(COLOR_BRIGHT_WHITE)

    assert_truthy(RSP_IS_ANSI_ENABLED MESSAGE "ANSI should had been enabled")
endfunction()

define_test("can enable ANSI (custom preset)" "can_enable_ansi_custom_preset")
function(can_enable_ansi_custom_preset)

    set(my_preset
        "MY_STYLE 1|35"
    )

    enable_ansi(PRESET ${my_preset})

    # Ensure that some of the predefined variables are defined, from default preset
    assert_defined(MY_STYLE MESSAGE "Custom preset not defined")

    # ----------------------------------------------------------------------- #
    # Cleanup

    disable_ansi(PRESET ${my_preset})

    assert_falsy(RSP_IS_ANSI_ENABLED MESSAGE "ANSI disable failure - 'is ansi enabled' state not changed")
    assert_not_defined(MY_STYLE MESSAGE "ANSI disable failure - failed to remove custom preset...")
endfunction()