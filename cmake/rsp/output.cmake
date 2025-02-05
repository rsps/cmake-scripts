# -------------------------------------------------------------------------------------------------------------- #
# Output
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/output module included")

include("rsp/helpers")
include("rsp/output/utils")
include("rsp/output/ansi")

# -------------------------------------------------------------------------------------------------------------- #
# Defaults...
# -------------------------------------------------------------------------------------------------------------- #

if (NOT DEFINED RSP_DEFAULT_LABEL_FORMAT)

    # Default label format
    #
    # The "%label%" is automatically replaced with
    # the actual label to be displayed.
    #
    # @see output()
    #
    set(RSP_DEFAULT_LABEL_FORMAT "%label%: " CACHE STRING " RSP Default label format for output()")
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Output related functions & macros
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "output")

    #! output : Output a message to stdout or stderr (Cmake's message type specific)
    #
    # @see https://cmake.org/cmake/help/latest/command/message.html
    # @see RSP_DEFAULT_LABEL_FORMAT
    #
    # @param <string|variable|list> message     The message to output. If a variable is given, its value will be used.
    #                                           If a list is detected given, then each item in the list will be output,
    #                                           using the LIST_SEPARATOR.
    # @param [<mode>]                           Option - Cmake's message type. Defaults to NOTICE, when not specified.
    # @param [OUTPUT <variable>]                Optional - If specified, message is assigned to output variable instead of
    #                                           being printed to stdout or stderr.
    # @param [LABEL <string>]                   Optional - A label to display as the message's prefix. Defaults to empty string.
    #                                           The label does NOT affect how cmake treats the message, it is purely for
    #                                           visual purposes.
    # @param [LABEL_FORMAT <string>]            Optional - A format string in which the actual label is inserted.
    #                                           E.g. "(%label%): ". The "%label%" is replaced with the provided label.
    #                                           Defaults to RSP_DEFAULT_LABEL_FORMAT when none given.
    # @param [LIST_SEPARATOR <string>]          Optional - Separator to used, if a list variable is given as message.
    #                                           Defaults to RSP_DEFAULT_LIST_SEPARATOR.
    #
    # @return
    #       [OUTPUT]                            The resulting output variable, if OUTPUT was specified.
    #
    function(output message)
        set(options "${RSP_CMAKE_MESSAGE_MODES}")
        set(oneValueArgs OUTPUT LABEL LABEL_FORMAT LIST_SEPARATOR)
        set(multiValueArgs "")

        # Ensure to parse named arguments only AFTER the "message" parameter, or strange
        # behaviour can occur, if one or more of the arguments contain escape codes.
        #
        # The following will NOT work, if e.g. LABEL contains ANSI escape codes and a LABEL_FORMAT
        # is also provided. The LABEL or other arguments are just not parsed correctly!
        #   cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}) # Might fail...

        cmake_parse_arguments(PARSE_ARGV 1 INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}")

        # ---------------------------------------------------------------------------------------------- #

        # Message mode
        resolve_msg_mode("NOTICE")

        # Label format
        set(label_format "${RSP_DEFAULT_LABEL_FORMAT}")
        if (DEFINED INPUT_LABEL_FORMAT)
            set(label_format "${INPUT_LABEL_FORMAT}")
        endif ()

        # Label
        set(label "")
        if (DEFINED INPUT_LABEL)
            string(REPLACE "%label%" "${INPUT_LABEL}" label "${label_format}")
        endif ()

        # List separator
        resolve_list_separator()

        # ---------------------------------------------------------------------------------------------- #
        # Resolve message

        set(buffer "${message}")
        if(DEFINED ${message})
            message(VERBOSE "message is a variable (${message})")
            extract_value(resolved_msg ${message})

            # Debug
            # message(NOTICE "resolved message: ${resolved_msg}")

            # If the variable is a list, then append each entry to buffer
            list(LENGTH resolved_msg length)
            if (length GREATER 1)
                # Replace every semicolon with a newline character.
                string(REPLACE ";" "${separator}" resolved_msg "${resolved_msg}")
            endif ()

            # Use the resolved message to buffer.
            set(buffer "${resolved_msg}")
        endif ()

        # Prefix final message with evt. label
        set(formatted_output "${label}${buffer}")

        # ---------------------------------------------------------------------------------------------- #

        # Assign to output variable, if requested and stop any further processing.
        if (DEFINED INPUT_OUTPUT)
            set("${INPUT_OUTPUT}" "${formatted_output}")
            return(PROPAGATE "${INPUT_OUTPUT}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Attempt to keep the formatting, even when the message mode is
        # one that cmake formats.
        set(target_modes "AUTHOR_WARNING;WARNING;SEND_ERROR;FATAL_ERROR")
        list(FIND target_modes ${msg_mode} mode_exists)
        if (NOT mode_exists EQUAL -1)

            # The "Carriage return (enter key)" seems to abort cmake's default
            # formatting. However, each newline must be indented with a space,
            # such that message() interprets it as a formatted message.
            string(ASCII 13 CR)
            set(formatted_output "${CR}${formatted_output}")
            string(REPLACE "\n\t" "\n   " formatted_output "${formatted_output}")
            string(REPLACE "\n" "\n " formatted_output "${formatted_output}")
        endif ()

        # Finally, output the message...
        message(${msg_mode} "${formatted_output}")

    endfunction()
endif ()