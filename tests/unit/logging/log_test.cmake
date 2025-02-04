include("rsp/testing")
include("rsp/logging")

define_test_case(
    "Log Test"
    LABELS "logging;log"
)

# -------------------------------------------------------------------------------------------------------------- #
# Data Providers
# -------------------------------------------------------------------------------------------------------------- #

function(provides_log_functions output)
    set("${output}"
        "${EMERGENCY_LEVEL}"
        "${ALERT_LEVEL}"
        "${CRITICAL_LEVEL}"
        "${ERROR_LEVEL}"
        "${WARNING_LEVEL}"
        "${NOTICE_LEVEL}"
        "${INFO_LEVEL}"
        "${DEBUG_LEVEL}"
    )
    return (PROPAGATE "${output}")
endfunction()

# -------------------------------------------------------------------------------------------------------------- #
# Actual tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("can log a simple message" "can_log_simple_msg" DATA_PROVIDER "provides_log_functions")
function(can_log_simple_msg log_function)

    set(msg "Where is the swashbuckling mainland?")
    cmake_language(CALL "${log_function}" "${msg}" OUTPUT result)

    assert_string_contains("${result}" "${msg}" MESSAGE "Incorrect message logged for ${log_function}")
endfunction()

define_test("can log a variable" "can_log_variable_msg" DATA_PROVIDER "provides_log_functions")
function(can_log_variable_msg log_function)

    set(msg "You have to travel, and praise issue by your disappearing.")
    cmake_language(CALL "${log_function}" msg OUTPUT result)

    assert_string_contains("${result}" "${msg}" MESSAGE "Incorrect message logged for ${log_function}")
endfunction()

define_test("can log a list" "can_log_list_msg" DATA_PROVIDER "provides_log_functions")
function(can_log_list_msg log_function)

    set(my_list "aaa;bbb;ccc;ddd")
    cmake_language(CALL "${log_function}" my_list OUTPUT result)

    foreach (item IN LISTS my_list)
        assert_string_contains("${result}" "${item}" MESSAGE "Incorrect message logged for ${log_function}")
    endforeach ()
endfunction()

define_test("can log a list using custom separator" "can_log_list_separator_msg" DATA_PROVIDER "provides_log_functions")
function(can_log_list_separator_msg log_function)

    set(my_list "aaa;bbb;ccc;ddd")
    set(list_separator ", ")
    cmake_language(CALL "${log_function}" my_list OUTPUT result LIST_SEPARATOR "${list_separator}")

    string(REPLACE ";" "${list_separator}" expected "${my_list}")
    assert_string_contains("${result}" "${expected}" MESSAGE "Incorrect message logged for ${log_function}")
endfunction()

define_test("can log a message with context" "can_log_msg_context" DATA_PROVIDER "provides_log_functions")
function(can_log_msg_context log_function)

    set(msg "Where is the swashbuckling mainland?")
    set(foo "bar")
    set(name "John Doe")
    set(psr "alpha")
    set(age 34)

    cmake_language(CALL "${log_function}" "${msg}" CONTEXT foo name psr age OUTPUT result)

    assert_string_contains("${result}" "${msg}" MESSAGE "Incorrect message logged for ${log_function}")
    assert_string_contains("${result}" "${foo}" MESSAGE "Context item (foo) not logged for ${log_function}")
    assert_string_contains("${result}" "${name}" MESSAGE "Context item (name) not logged for ${log_function}")
    assert_string_contains("${result}" "${age}" MESSAGE "Context item (age) not logged for ${log_function}")
endfunction()

define_test("log message contains a timestamp" "log_msg_has_timestamp" DATA_PROVIDER "provides_log_functions")
function(log_msg_has_timestamp log_function)

    cmake_language(CALL "${log_function}" "foo" OUTPUT result)

    string(TOLOWER "${result}" result)
    assert_string_contains("${result}" "timestamp" MESSAGE "No timestamp logged for ${log_function}")
endfunction()

define_test("can set cmake message mode" "can_log_with_cmake_mgs_mode" DATA_PROVIDER "provides_log_functions")
function(can_log_with_cmake_mgs_mode log_function)

    # Use "status" mode here, such that all log functions can be invoked
    # without side-effects.
    set(mode "STATUS")

    # If no failure, then test passes
    cmake_language(CALL "${log_function}" "Test of CMake message mode: ${mode}" ${mode})
endfunction()

define_test(
    "can use cmake message mode to stop build"
    "can_stop_build_with_mgs_mode"
    DATA_PROVIDER "provides_log_functions"
    EXPECT_FAILURE
)
function(can_stop_build_with_mgs_mode log_function)

    # Here, each call to a log function should result in cmake stopping
    # the build process entirely, when mode is set to "fatal error"!
    set(mode "FATAL_ERROR")

    cmake_language(CALL "${log_function}" "Test of CMake message mode: ${mode}" ${mode})
endfunction()