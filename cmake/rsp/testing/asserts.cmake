# -------------------------------------------------------------------------------------------------------------- #
# Test Assertions
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/testing/asserts module included")

# -------------------------------------------------------------------------------------------------------------- #
# Truthy / Falsy
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

# TODO: ...

# -------------------------------------------------------------------------------------------------------------- #
# Comparisons
# -------------------------------------------------------------------------------------------------------------- #

# TODO: ...numbers
# TODO: ...strings (incl. regex)
# TODO: ...versions

# -------------------------------------------------------------------------------------------------------------- #
# Files
# -------------------------------------------------------------------------------------------------------------- #

# TODO: ...

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