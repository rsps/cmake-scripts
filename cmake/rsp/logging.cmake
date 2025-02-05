# -------------------------------------------------------------------------------------------------------------- #
# Logging
# -------------------------------------------------------------------------------------------------------------- #
#
# The herein defined console log functions and macros are heavily inspired by the "PSR-3: Logger Interface".
# Originally licensed as MIT - Copyright (c) 2012 PHP Framework Interoperability Group.
#
# @see https://github.com/php-fig/log
# @see https://www.php-fig.org/psr/psr-3/
#

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/logging module included")

include("rsp/helpers")
include("rsp/output")
include("rsp/logging/utils")

# -------------------------------------------------------------------------------------------------------------- #
# Defaults...
# -------------------------------------------------------------------------------------------------------------- #

# See `RSP_LOG_LEVELS` and `RSP_LOG_LEVELS_CMAKE`, in `rsp/logging/utils`.

# -------------------------------------------------------------------------------------------------------------- #
# Log functions
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "emergency")

    #! emergency : Log an "emergency" level message - System is unusable.
    #
    # @see log()
    #
    # @param <string|variable|list> message     The message to output. If a variable is given, its value will be used.
    #                                           If a list is detected given, then each item in the list will be output,
    #                                           using the LIST_SEPARATOR.
    # @param [<mode>]                           Option - Cmake's message type. Defaults to the `mode` that is
    #                                           associated with the specified `level`, defined in RSP_LOG_LEVELS_CMAKE.
    # @param [CONTEXT <variable>...]            Optional - Evt. variables to output in a "context" associated with the
    #                                           log message.
    # @param [OUTPUT <variable>]                Optional - If specified, message is assigned to output variable instead
    #                                           of being printed to stdout or stderr.
    # @param [LIST_SEPARATOR <string>]          Optional - Separator to used, if a list variable is given as message.
    #                                           Defaults to RSP_DEFAULT_LIST_SEPARATOR.
    #
    # @return
    #       [OUTPUT]                            The resulting output variable, if OUTPUT was specified.
    #
    function(emergency message)
        forward_to_log(EMERGENCY_LEVEL ${message})
    endfunction()
endif ()

if (NOT COMMAND "alert")

    #! alert : Log an "alert" level message - Action must be taken immediately.
    #
    # @see log()
    #
    # @param <string|variable|list> message     The message to output. If a variable is given, its value will be used.
    #                                           If a list is detected given, then each item in the list will be output,
    #                                           using the LIST_SEPARATOR.
    # @param [<mode>]                           Option - Cmake's message type. Defaults to the `mode` that is
    #                                           associated with the specified `level`, defined in RSP_LOG_LEVELS_CMAKE.
    # @param [CONTEXT <variable>...]            Optional - Evt. variables to output in a "context" associated with the
    #                                           log message.
    # @param [OUTPUT <variable>]                Optional - If specified, message is assigned to output variable instead
    #                                           of being printed to stdout or stderr.
    # @param [LIST_SEPARATOR <string>]          Optional - Separator to used, if a list variable is given as message.
    #                                           Defaults to RSP_DEFAULT_LIST_SEPARATOR.
    #
    # @return
    #       [OUTPUT]                            The resulting output variable, if OUTPUT was specified.
    #
    function(alert message)
        forward_to_log(ALERT_LEVEL ${message})
    endfunction()
endif ()

if (NOT COMMAND "critical")

    #! critical : Log a "critical" level message - Critical conditions.
    # E.g. Application component unavailable, unexpected exception.
    #
    # @see log()
    #
    # @param <string|variable|list> message     The message to output. If a variable is given, its value will be used.
    #                                           If a list is detected given, then each item in the list will be output,
    #                                           using the LIST_SEPARATOR.
    # @param [<mode>]                           Option - Cmake's message type. Defaults to the `mode` that is
    #                                           associated with the specified `level`, defined in RSP_LOG_LEVELS_CMAKE.
    # @param [CONTEXT <variable>...]            Optional - Evt. variables to output in a "context" associated with the
    #                                           log message.
    # @param [OUTPUT <variable>]                Optional - If specified, message is assigned to output variable instead
    #                                           of being printed to stdout or stderr.
    # @param [LIST_SEPARATOR <string>]          Optional - Separator to used, if a list variable is given as message.
    #                                           Defaults to RSP_DEFAULT_LIST_SEPARATOR.
    #
    # @return
    #       [OUTPUT]                            The resulting output variable, if OUTPUT was specified.
    #
    function(critical message)
        forward_to_log(CRITICAL_LEVEL ${message})
    endfunction()
endif ()

if (NOT COMMAND "error")

    #! error : Log an "error" level message.
    #
    # @see log()
    #
    # @param <string|variable|list> message     The message to output. If a variable is given, its value will be used.
    #                                           If a list is detected given, then each item in the list will be output,
    #                                           using the LIST_SEPARATOR.
    # @param [<mode>]                           Option - Cmake's message type. Defaults to the `mode` that is
    #                                           associated with the specified `level`, defined in RSP_LOG_LEVELS_CMAKE.
    # @param [CONTEXT <variable>...]            Optional - Evt. variables to output in a "context" associated with the
    #                                           log message.
    # @param [OUTPUT <variable>]                Optional - If specified, message is assigned to output variable instead
    #                                           of being printed to stdout or stderr.
    # @param [LIST_SEPARATOR <string>]          Optional - Separator to used, if a list variable is given as message.
    #                                           Defaults to RSP_DEFAULT_LIST_SEPARATOR.
    #
    # @return
    #       [OUTPUT]                            The resulting output variable, if OUTPUT was specified.
    #
    function(error message)
        forward_to_log(ERROR_LEVEL ${message})
    endfunction()
endif ()

if (NOT COMMAND "warning")

    #! warning : Log a "warning" level message - Exceptional occurrences that are not errors.
    #
    # @see log()
    #
    # @param <string|variable|list> message     The message to output. If a variable is given, its value will be used.
    #                                           If a list is detected given, then each item in the list will be output,
    #                                           using the LIST_SEPARATOR.
    # @param [<mode>]                           Option - Cmake's message type. Defaults to the `mode` that is
    #                                           associated with the specified `level`, defined in RSP_LOG_LEVELS_CMAKE.
    # @param [CONTEXT <variable>...]            Optional - Evt. variables to output in a "context" associated with the
    #                                           log message.
    # @param [OUTPUT <variable>]                Optional - If specified, message is assigned to output variable instead
    #                                           of being printed to stdout or stderr.
    # @param [LIST_SEPARATOR <string>]          Optional - Separator to used, if a list variable is given as message.
    #                                           Defaults to RSP_DEFAULT_LIST_SEPARATOR.
    #
    # @return
    #       [OUTPUT]                            The resulting output variable, if OUTPUT was specified.
    #
    function(warning message)
        forward_to_log(WARNING_LEVEL ${message})
    endfunction()
endif ()

if (NOT COMMAND "notice")

    #! notice : Log a "notice" level message - Normal but significant events.
    #
    # @see log()
    #
    # @param <string|variable|list> message     The message to output. If a variable is given, its value will be used.
    #                                           If a list is detected given, then each item in the list will be output,
    #                                           using the LIST_SEPARATOR.
    # @param [<mode>]                           Option - Cmake's message type. Defaults to the `mode` that is
    #                                           associated with the specified `level`, defined in RSP_LOG_LEVELS_CMAKE.
    # @param [CONTEXT <variable>...]            Optional - Evt. variables to output in a "context" associated with the
    #                                           log message.
    # @param [OUTPUT <variable>]                Optional - If specified, message is assigned to output variable instead
    #                                           of being printed to stdout or stderr.
    # @param [LIST_SEPARATOR <string>]          Optional - Separator to used, if a list variable is given as message.
    #                                           Defaults to RSP_DEFAULT_LIST_SEPARATOR.
    #
    # @return
    #       [OUTPUT]                            The resulting output variable, if OUTPUT was specified.
    #
    function(notice message)
        forward_to_log(NOTICE_LEVEL ${message})
    endfunction()
endif ()

if (NOT COMMAND "info")

    #! info : Log an "info" level message - Informational events.
    #
    # @see log()
    #
    # @param <string|variable|list> message     The message to output. If a variable is given, its value will be used.
    #                                           If a list is detected given, then each item in the list will be output,
    #                                           using the LIST_SEPARATOR.
    # @param [<mode>]                           Option - Cmake's message type. Defaults to the `mode` that is
    #                                           associated with the specified `level`, defined in RSP_LOG_LEVELS_CMAKE.
    # @param [CONTEXT <variable>...]            Optional - Evt. variables to output in a "context" associated with the
    #                                           log message.
    # @param [OUTPUT <variable>]                Optional - If specified, message is assigned to output variable instead
    #                                           of being printed to stdout or stderr.
    # @param [LIST_SEPARATOR <string>]          Optional - Separator to used, if a list variable is given as message.
    #                                           Defaults to RSP_DEFAULT_LIST_SEPARATOR.
    #
    # @return
    #       [OUTPUT]                            The resulting output variable, if OUTPUT was specified.
    #
    function(info message)
        forward_to_log(INFO_LEVEL ${message})
    endfunction()
endif ()

if (NOT COMMAND "debug")

    #! debug : Log a "debug" level message - Debugging information or events.
    #
    # @see log()
    #
    # @param <string|variable|list> message     The message to output. If a variable is given, its value will be used.
    #                                           If a list is detected given, then each item in the list will be output,
    #                                           using the LIST_SEPARATOR.
    # @param [<mode>]                           Option - Cmake's message type. Defaults to the `mode` that is
    #                                           associated with the specified `level`, defined in RSP_LOG_LEVELS_CMAKE.
    # @param [CONTEXT <variable>...]            Optional - Evt. variables to output in a "context" associated with the
    #                                           log message.
    # @param [OUTPUT <variable>]                Optional - If specified, message is assigned to output variable instead
    #                                           of being printed to stdout or stderr.
    # @param [LIST_SEPARATOR <string>]          Optional - Separator to used, if a list variable is given as message.
    #                                           Defaults to RSP_DEFAULT_LIST_SEPARATOR.
    #
    # @return
    #       [OUTPUT]                            The resulting output variable, if OUTPUT was specified.
    #
    function(debug message)
        forward_to_log(DEBUG_LEVEL ${message})
    endfunction()
endif ()

if (NOT COMMAND "log")

    #! log : Log a message with an arbitrary level
    #
    # @see rsp/output::output()
    #
    # @param <string> level                     The log level (see RSP_LOG_LEVELS)
    # @param <string|variable|list> message     The message to output. If a variable is given, its value will be used.
    #                                           If a list is detected given, then each item in the list will be output,
    #                                           using the LIST_SEPARATOR.
    # @param [<mode>]                           Option - Cmake's message type. Defaults to the `mode` that is
    #                                           associated with the specified `level`, defined in RSP_LOG_LEVELS_CMAKE.
    # @param [CONTEXT <variable>...]            Optional - Evt. variables to output in a "context" associated with the
    #                                           log message.
    # @param [OUTPUT <variable>]                Optional - If specified, message is assigned to output variable instead
    #                                           of being printed to stdout or stderr.
    # @param [LIST_SEPARATOR <string>]          Optional - Separator to used, if a list variable is given as message.
    #                                           Defaults to RSP_DEFAULT_LIST_SEPARATOR.
    #
    # @return
    #       [OUTPUT]                            The resulting output variable, if OUTPUT was specified.
    #
    function(log level message)
        set(options "${RSP_CMAKE_MESSAGE_MODES}")
        set(oneValueArgs OUTPUT LIST_SEPARATOR)
        set(multiValueArgs CONTEXT)

        cmake_parse_arguments(PARSE_ARGV 2 INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}")

        # ---------------------------------------------------------------------------------------------- #

        # Resolve the requested log level
        extract_value(log_level "${level}")
        list(FIND RSP_LOG_LEVELS "${log_level}" level_exists)
        if (level_exists EQUAL -1)
            message(FATAL_ERROR "Log level '${log_level}' is NOT supported")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Resolve CMake's message mode, acc. to specified log level.
        resolve_cmake_message_mode()

        # ---------------------------------------------------------------------------------------------- #

        # Format message label, acc. to the log level
        format_log_level_label("${log_level}" label)

        # List separator
        resolve_list_separator()

        # ---------------------------------------------------------------------------------------------- #

        set(buffer "")

        # Resolve and format the message - similar to what output() does...
        set(resolved_msg "${message}")
        if(DEFINED ${message})
            message(VERBOSE "log message is a variable (${message})")
            extract_value(resolved_msg ${message})

            # If the variable is a list, then append each entry to buffer
            list(LENGTH resolved_msg length)
            if (length GREATER 1)
                # Replace every semicolon with a newline character.
                string(REPLACE ";" "${separator}" resolved_msg "${resolved_msg}")
            endif ()
        endif ()

        # Format the log message, if needed...
        format_log_message("${log_level}" "${resolved_msg}" buffer)

        # ---------------------------------------------------------------------------------------------- #

        # Context
        if (DEFINED INPUT_CONTEXT AND NOT INPUT_CONTEXT STREQUAL "")
            format_log_context("${log_level}" "${INPUT_CONTEXT}" formatted_context)
            string(APPEND buffer "${formatted_context}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # timestamp
        if (RSP_LOG_SHOW_TIMESTAMP)
            format_log_timestamp("${log_level}" timestamp)
            string(APPEND buffer "${timestamp}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        set(formatted_output "${buffer}")

        # ---------------------------------------------------------------------------------------------- #

        # Finally, output the log message
        output(${formatted_output}
            "${msg_mode}"
            OUTPUT ${INPUT_OUTPUT}
            LABEL "${label}"
        )

        # ---------------------------------------------------------------------------------------------- #

        # Assign to output variable, if requested and stop any further processing.
        if (DEFINED INPUT_OUTPUT)
            return(PROPAGATE "${INPUT_OUTPUT}")
        endif ()
    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Internals
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND forward_to_log)

    #! forward_to_log : Macro that forwards current function call to log()
    #
    # WARNING: Macro is intended to be used internally within various logging
    # level functions, w.g. critical(), error(), warning()...etc
    # It is responsible for forwarding arguments to the log() function and
    # return evt. assigned OUTPUT.
    #
    # @see log()
    #
    # @internal
    #
    macro(forward_to_log log_level message)
        set(options "${RSP_CMAKE_MESSAGE_MODES}")
        set(oneValueArgs OUTPUT LIST_SEPARATOR)
        set(multiValueArgs CONTEXT)

        cmake_parse_arguments(PARSE_ARGV 1 INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}")

        # ---------------------------------------------------------------------------------------------- #

        extract_value(log_level ${log_level})
        resolve_cmake_message_mode()

        # ---------------------------------------------------------------------------------------------- #

        log("${log_level}" ${message} "${msg_mode}"
            OUTPUT ${INPUT_OUTPUT}
            CONTEXT ${INPUT_CONTEXT}
            LIST_SEPARATOR ${INPUT_LIST_SEPARATOR}
        )

        # ---------------------------------------------------------------------------------------------- #

        if (DEFINED INPUT_OUTPUT)
            return(PROPAGATE "${INPUT_OUTPUT}")
        endif ()
    endmacro()
endif ()
