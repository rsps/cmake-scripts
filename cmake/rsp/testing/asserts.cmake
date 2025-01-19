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

    #! assert_is_callable : Assert key to be a callable command or marco
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

    #! assert_is_not_callable : Assert key not to be a callable command or marco
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

    #! assert_in_list : Assert key (value) to be inlist
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

    #! assert_not_in_list : Assert key (value) not to be inlist
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

# TODO: ...gt, gte, lt, lte... etc

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

        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "OUTPUT;EXPECTED;ACTUAL;OPERATOR")
        foreach (arg ${requiredArgs})
            if (NOT DEFINED INPUT_${arg})
                message(FATAL_ERROR "${arg} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # ------------------------------------------------------------------------------------- #

        extract_value(INPUT_EXPECTED "${INPUT_EXPECTED}")
        extract_value(INPUT_ACTUAL "${INPUT_ACTUAL}")

        # Default output
        set("${INPUT_OUTPUT}" FALSE)

        # If comparison passes, change output to true...
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