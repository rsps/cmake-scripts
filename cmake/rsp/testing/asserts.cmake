# -------------------------------------------------------------------------------------------------------------- #
# Test Assertions
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/testing/asserts module included")

include("rsp/helpers")

# -------------------------------------------------------------------------------------------------------------- #
# Boolean
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "assert_truthy")

    #! assert_truthy : Assert key to be truthy
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#basic-expressions
    #
    # @param <variable> key         The key to assert
    # @param [MESSAGE <string>]     Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_truthy key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        if (NOT ${key})
            message(FATAL_ERROR "Expected '${key}' to be truthy." "${msg}")
        endif ()
    endfunction()
endif ()

if (NOT COMMAND "assert_falsy")

    #! assert_falsy : Assert key to be falsy
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#basic-expressions
    #
    # @param <variable> key         The key to assert
    # @param [MESSAGE <string>]     Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_falsy key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        if (${key})
            message(FATAL_ERROR "Expected '${key}' to be falsy." "${msg}")
        endif ()
    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Existence
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "assert_defined")

    #! assert_defined : Assert key to be defined
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#defined
    #
    # @param <variable> key         The key to assert
    # @param [MESSAGE <string>]     Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_defined key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        if (NOT DEFINED ${key})
            message(FATAL_ERROR "'${key}' is not defined, but was expected to be." "${msg}")
        endif ()
    endfunction()
endif ()

if (NOT COMMAND "assert_not_defined")

    #! assert_not_defined : Assert key to not be defined
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#defined
    #
    # @param <variable> key         The key to assert
    # @param [MESSAGE <string>]     Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_not_defined key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        if (DEFINED ${key})
            message(FATAL_ERROR "'${key}' is defined, but was expected not to be." "${msg}")
        endif ()
    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Commands & Macros
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "assert_is_callable")

    #! assert_is_callable : Assert key to be a callable command or macro
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#command
    #
    # @param <variable> key         The key to assert
    # @param [MESSAGE <string>]     Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_is_callable key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        if (NOT COMMAND ${key})
            message(FATAL_ERROR "'${key}' is not callable, but was expected to be so." "${msg}")
        endif ()
    endfunction()
endif ()

if (NOT COMMAND "assert_is_not_callable")

    #! assert_is_not_callable : Assert key not to be a callable command or macro
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#command
    #
    # @param <variable> key         The key to assert
    # @param [MESSAGE <string>]     Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_is_not_callable key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        if (COMMAND ${key})
            message(FATAL_ERROR "'${key}' is callable, but was not expected to be so." "${msg}")
        endif ()
    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Lists
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "assert_in_list")

    #! assert_in_list : Assert key (value) to be in given list
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#in-list
    #
    # @param <variable|value> key   The key (or value) to be in list
    # @param <variable> list_key    The list expected to contain key or value
    # @param [MESSAGE <string>]     Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_in_list key list_key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        if (NOT (${key} IN_LIST ${list_key}))
            message(FATAL_ERROR "'${key}' is not in list ${list}." "${msg}")
        endif ()
    endfunction()
endif ()

if (NOT COMMAND "assert_not_in_list")

    #! assert_not_in_list : Assert key (value) not to be in given list
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#in-list
    #
    # @param <variable|value> key   The key (or value) not to be in list
    # @param <variable> list_key    The list expected not to contain key or value
    # @param [MESSAGE <string>]     Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_not_in_list key list_key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        if (${key} IN_LIST ${list_key})
            message(FATAL_ERROR "'${key}' is in list ${list}, but was not expected to be." "${msg}")
        endif ()
    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Numbers
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "assert_equals")

    #! assert_equals : Assert numeric keys or values equal each other
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#equal
    #
    # @param <variable|string> expected  The expected key or value
    # @param <variable|string> actual    The actual key or value
    # @param [MESSAGE <string>]          Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_equals expected_key actual_key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        assert_compare_values(
            OUTPUT result
            EXPECTED ${expected_key}
            ACTUAL ${actual_key}
            OPERATOR "EQUAL"
        )

        if (NOT result)
            extract_value(a "${actual_key}")
            extract_value(e "${expected_key}")

            message(FATAL_ERROR "Actual value ${a} does not equal expected value ${e}." "${msg}")
        endif ()

    endfunction()
endif ()

if (NOT COMMAND "assert_not_equals")

    #! assert_not_equals : Assert numeric keys or values do not equal each other
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#equal
    #
    # @param <variable|string> expected  The expected key or value
    # @param <variable|string> actual    The actual key or value
    # @param [MESSAGE <string>]          Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_not_equals expected_key actual_key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        assert_compare_values(
            OUTPUT result
            EXPECTED ${expected_key}
            ACTUAL ${actual_key}
            OPERATOR "EQUAL"
        )

        if (result)
            extract_value(a "${actual_key}")
            extract_value(e "${expected_key}")

            message(FATAL_ERROR "Actual value ${a} equals expected value ${e}, but was not expected to." "${msg}")
        endif ()

    endfunction()
endif ()

if (NOT COMMAND "assert_less_than")

    #! assert_less_than : Assert numeric key or value is less than specified value
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#less
    #
    # @param <variable|string> expected  The expected key or value
    # @param <variable|string> actual    The actual key or value that should be less than expected
    # @param [MESSAGE <string>]          Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_less_than expected_key actual_key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        assert_compare_values(
                OUTPUT result
                EXPECTED ${expected_key}
                ACTUAL ${actual_key}
                OPERATOR "LESS"
        )

        if (NOT result)
            extract_value(a "${actual_key}")
            extract_value(e "${expected_key}")

            message(FATAL_ERROR "Actual value ${a} is not less than ${e}." "${msg}")
        endif ()

    endfunction()
endif ()

if (NOT COMMAND "assert_less_than_or_equal")

    #! assert_less_than_or_equal : Assert numeric key or value is less than or equal
    # to the specified value
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#less-equal
    #
    # @param <variable|string> expected  The expected key or value
    # @param <variable|string> actual    The actual key or value that should be less than
    #                                    or equal to expected
    # @param [MESSAGE <string>]          Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_less_than_or_equal expected_key actual_key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        assert_compare_values(
                OUTPUT result
                EXPECTED ${expected_key}
                ACTUAL ${actual_key}
                OPERATOR "LESS_EQUAL"
        )

        if (NOT result)
            extract_value(a "${actual_key}")
            extract_value(e "${expected_key}")

            message(FATAL_ERROR "Actual value ${a} is not less than or equal to ${e}." "${msg}")
        endif ()

    endfunction()
endif ()

if (NOT COMMAND "assert_greater_than")

    #! assert_greater_than : Assert numeric key or value is greater than specified value
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#greater
    #
    # @param <variable|string> expected  The expected key or value
    # @param <variable|string> actual    The actual key or value that should be greater than expected
    # @param [MESSAGE <string>]          Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_greater_than expected_key actual_key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        assert_compare_values(
                OUTPUT result
                EXPECTED ${expected_key}
                ACTUAL ${actual_key}
                OPERATOR "GREATER"
        )

        if (NOT result)
            extract_value(a "${actual_key}")
            extract_value(e "${expected_key}")

            message(FATAL_ERROR "Actual value ${a} is not greater than ${e}." "${msg}")
        endif ()

    endfunction()
endif ()

if (NOT COMMAND "assert_greater_than_or_equal")

    #! assert_greater_than_or_equal : Assert numeric key or value is greater than or equal
    # to the specified value
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#greater-equal
    #
    # @param <variable|string> expected  The expected key or value
    # @param <variable|string> actual    The actual key or value that should be greater than
    #                                    or equal to expected
    # @param [MESSAGE <string>]          Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_greater_than_or_equal expected_key actual_key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        assert_compare_values(
                OUTPUT result
                EXPECTED ${expected_key}
                ACTUAL ${actual_key}
                OPERATOR "GREATER_EQUAL"
        )

        if (NOT result)
            extract_value(a "${actual_key}")
            extract_value(e "${expected_key}")

            message(FATAL_ERROR "Actual value ${a} is not greater than or equal to ${e}." "${msg}")
        endif ()

    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Strings
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "assert_string_equals")

    #! assert_string_equals : Assert string keys or values equal each other
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#strequal
    #
    # @param <variable|string> expected  The expected key or value
    # @param <variable|string> actual    The actual key or value
    # @param [MESSAGE <string>]          Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_string_equals expected_key actual_key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        assert_compare_values(
            OUTPUT result
            EXPECTED ${expected_key}
            ACTUAL ${actual_key}
            OPERATOR "STREQUAL"
        )

        if (NOT result)
            extract_value(a "${actual_key}")
            extract_value(e "${expected_key}")

            message(FATAL_ERROR "Actual '${a}' does not equal expected '${e}'." "${msg}")
        endif ()

    endfunction()
endif ()

if (NOT COMMAND "assert_string_not_equals")

    #! assert_string_not_equals : Assert string keys or values do not equal each other
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#strequal
    #
    # @param <variable|string> expected  The expected key or value
    # @param <variable|string> actual    The actual key or value
    # @param [MESSAGE <string>]          Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_string_not_equals expected_key actual_key)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        assert_compare_values(
            OUTPUT result
            EXPECTED ${expected_key}
            ACTUAL ${actual_key}
            OPERATOR "STREQUAL"
        )

        if (result)
            extract_value(a "${actual_key}")
            extract_value(e "${expected_key}")

            message(FATAL_ERROR "Actual '${a}' equals expected '${e}', but was not expected to." "${msg}")
        endif ()

    endfunction()
endif ()

if (NOT COMMAND "assert_string_empty")

    #! assert_string_empty : Assert given string is empty
    #
    # @see https://cmake.org/cmake/help/latest/command/string.html#length
    #
    # @param <string> str        The string value
    # @param [MESSAGE <string>]  Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_string_empty str)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        string(LENGTH "${str}" length)

        if (NOT length EQUAL 0)
            message(FATAL_ERROR "String '${str}' (${length} bytes) was expected to be empty." "${msg}")
        endif ()

    endfunction()
endif ()

if (NOT COMMAND "assert_string_not_empty")

    #! assert_string_not_empty : Assert given string is not empty
    #
    # @see https://cmake.org/cmake/help/latest/command/string.html#length
    #
    # @param <string> str        The string value
    # @param [MESSAGE <string>]  Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_string_not_empty str)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        string(LENGTH "${str}" length)

        if (length EQUAL 0)
            message(FATAL_ERROR "String '${str}' (${length} bytes) is empty." "${msg}")
        endif ()

    endfunction()
endif ()

if (NOT COMMAND "assert_string_contains")

    #! assert_string_contains : Assert given string contains given substring
    #
    # @see https://cmake.org/cmake/help/latest/command/string.html#length
    #
    # @param <string> str        The target string value
    # @param <string> sub_str    The substring
    # @param [MESSAGE <string>]  Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_string_contains str sub_str)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        string(FIND "${str}" "${sub_str}" result)

        if (result EQUAL -1)
            message(FATAL_ERROR "String '${str}' does not contain '${sub_str}'." "${msg}")
        endif ()

    endfunction()
endif ()

if (NOT COMMAND "assert_string_not_contains")

    #! assert_string_not_contains : Assert given string does not contain given substring
    #
    # @see https://cmake.org/cmake/help/latest/command/string.html#length
    #
    # @param <string> str        The target string value
    # @param <string> sub_str    The substring
    # @param [MESSAGE <string>]  Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_string_not_contains str sub_str)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        string(FIND "${str}" "${sub_str}" result)

        if (NOT result EQUAL -1)
            message(FATAL_ERROR "String '${str}' contains '${sub_str}', but was not expected to." "${msg}")
        endif ()

    endfunction()
endif ()

# TODO: ...
# TODO: ...gt, gte, lt, lte... etc
# TODO: ...regex

# -------------------------------------------------------------------------------------------------------------- #
# Versions
# -------------------------------------------------------------------------------------------------------------- #

# TODO: ...
# TODO: ...gt, gte, lt, lte... etc

# -------------------------------------------------------------------------------------------------------------- #
# Files & Paths
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "assert_file_exists")

    #! assert_file_exists : Assert file exists
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#exists
    #
    # @param <string> path          Path to file
    # @param [MESSAGE <string>]     Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_file_exists path)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        if (NOT EXISTS "${path}")
            message(FATAL_ERROR "file '${path}' does not exist." "${msg}")
        endif ()
    endfunction()
endif ()

if (NOT COMMAND "assert_file_not_exists")

    #! assert_file_not_exists : Assert file does not exists
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#exists
    #
    # @param <string> path           Path to file
    # @param [MESSAGE <string>]     Optional message to output if assertion fails
    #
    # @throws
    #
    function(assert_file_not_exists path)
        set(oneValueArgs MESSAGE)
        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})
        format_assert_message(msg "${INPUT_MESSAGE}")

        # ------------------------------------------------------------------------------------- #

        if (EXISTS "${path}")
            message(FATAL_ERROR "file '${path}' exist, but was not expected to." "${msg}")
        endif ()
    endfunction()
endif ()

# TODO: ...
# TODO: ...is dir, is file, is symlink, file exists... etc

# -------------------------------------------------------------------------------------------------------------- #
# Misc.
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "assert_compare_values")

    #! assert_compare_values : Compares two keys / values using specified operator
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#comparisons
    #
    # @param OUTPUT <variable>          The output variable to assign the found version tag
    # @param EXPECTED <variable>        Expected key or value
    # @param ACTUAL <variable>          Actual key or value
    # @param OPERATOR <string>          Cmake comparison operator to use, e.g. LESS_EQUAL
    #
    # @return
    #     [OUTPUT]                      True if comparison passes, false otherwise
    #
    # @throws If OPERATOR is not supported by cmake
    #
    function(assert_compare_values)
        set(oneValueArgs OUTPUT EXPECTED ACTUAL OPERATOR)

        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
        requires_arguments("OUTPUT;EXPECTED;ACTUAL;OPERATOR" INPUT)

        # ------------------------------------------------------------------------------------- #

        extract_value(INPUT_EXPECTED "${INPUT_EXPECTED}")
        extract_value(INPUT_ACTUAL "${INPUT_ACTUAL}")

        # Default output
        set("${INPUT_OUTPUT}" FALSE)

        # If comparison passes, change output to true...
        message(VERBOSE "Comparing: ${INPUT_ACTUAL} ${INPUT_OPERATOR} ${INPUT_EXPECTED}")

        if (INPUT_ACTUAL ${INPUT_OPERATOR} INPUT_EXPECTED)
            set("${INPUT_OUTPUT}" TRUE)
        endif ()

        # Debug
        # dd(INPUT_OUTPUT "${INPUT_OUTPUT}" INPUT_EXPECTED INPUT_ACTUAL INPUT_OPERATOR)

        return(PROPAGATE "${INPUT_OUTPUT}")
    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Internals
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "format_assert_message")

    #! format_assert_message : Formats assertion message
    #
    # @internal
    #
    # @param output     The variable to assign result to
    # @param message    Assertion message
    #
    # @return
    #     [output]      Formatted message
    #
    function(format_assert_message output message)
        set("${output}" "")
        if (message STRGREATER "")
            set("${output}" "\n${message}\n")
        endif ()

        return(PROPAGATE "${output}")
    endfunction()
endif ()