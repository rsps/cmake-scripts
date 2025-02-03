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

# -------------------------------------------------------------------------------------------------------------- #
# Defaults...
# -------------------------------------------------------------------------------------------------------------- #

if (NOT DEFINED RSP_LOG_LEVELS)

    # System is unusable.
    set(EMERGENCY_LEVEL "emergency" CACHE STRING "RSP log level")

    # Action must be taken immediately.
    set(ALERT_LEVEL "alert" CACHE STRING "RSP log level")

    # Critical conditions.
    set(CRITICAL_LEVEL "critical" CACHE STRING "RSP log level")

    # Runtime errors that do not require immediate action but should typically
    # be logged and monitored.
    set(ERROR_LEVEL "error" CACHE STRING "RSP log level")

    # Exceptional occurrences that are not errors.
    set(WARNING_LEVEL "warning" CACHE STRING "RSP log level")

    # Normal but significant events.
    set(NOTICE_LEVEL "notice" CACHE STRING "RSP log level")

    # Interesting events.
    set(INFO_LEVEL "info" CACHE STRING "RSP log level")

    # Detailed debug information.
    set(DEBUG_LEVEL "debug" CACHE STRING "RSP log level")

    # PSR Log levels
    #
    # @see https://www.php-fig.org/psr/psr-3/#5-psrlogloglevel
    #
    set(RSP_LOG_LEVELS
        "${EMERGENCY_LEVEL}"
        "${ALERT_LEVEL}"
        "${CRITICAL_LEVEL}"
        "${ERROR_LEVEL}"
        "${WARNING_LEVEL}"
        "${NOTICE_LEVEL}"
        "${INFO_LEVEL}"
        "${DEBUG_LEVEL}"

        CACHE STRING "RSP log levels"
    )
endif ()


if (NOT DEFINED RSP_LOG_LEVELS_CMAKE)

    # A "map" of the PSR defined log levels and what each
    # level corresponds to for cmake's modes / types.
    #
    # This "map" is used internally by log(), when no `mode`
    # argument has been specified.
    #
    # @see https://www.php-fig.org/psr/psr-3/#5-psrlogloglevel
    # @see https://cmake.org/cmake/help/latest/command/message.html#general-messages
    #
    set(RSP_LOG_LEVELS_CMAKE
        "${EMERGENCY_LEVEL} FATAL_ERROR"
        "${ALERT_LEVEL} FATAL_ERROR"
        "${CRITICAL_LEVEL} FATAL_ERROR"
        "${ERROR_LEVEL} SEND_ERROR"
        "${WARNING_LEVEL} WARNING"
        "${NOTICE_LEVEL} NOTICE"
        "${INFO_LEVEL} NOTICE"
        "${DEBUG_LEVEL} DEBUG"

        CACHE STRING " RSP log levels map for cmake's message mode"
    )
endif ()

if (NOT DEFINED RSP_LOG_SHOW_TIMESTAMP)

    # Show timestamp for log entries
    set(RSP_LOG_SHOW_TIMESTAMP true CACHE BOOL " RSP show timestamp for log entries")
endif ()

if (NOT DEFINED RSP_LOG_TIMESTAMP_FORMAT)

    # Log timestamp format
    set(RSP_LOG_TIMESTAMP_FORMAT "%Y-%m-%d %H:%M:%S.%f" CACHE BOOL " RSP log timestamp format")
endif ()

if (NOT DEFINED RSP_LOG_INDENT)

    # Indentation for log context, timestamp,...etc
    set(RSP_LOG_INDENT "   " CACHE STRING " RSP ident for log context, timestamp...etc")
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Log functions
# -------------------------------------------------------------------------------------------------------------- #

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
    #                                           NOTICE, when not specified.
    # @param [OUTPUT <variable>]                Optional - If specified, message is assigned to output variable instead of
    #                                           being printed to stdout or stderr.
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
        set(default_cmake_msg_mode "NOTICE")
        foreach (lvl IN LISTS RSP_LOG_LEVELS_CMAKE)
            string(REPLACE " " ";" parts "${lvl}")

            # name = PSR log level, value = CMake message mode
            list(GET parts 0 name)
            list(GET parts 1 value)

            if ("${name}" STREQUAL "${log_level}")
                message(VERBOSE "Mapping ${log_level} level to cmake message mode ${value}")

                set(default_cmake_msg_mode "${value}")
                break()
            endif ()
        endforeach ()

        # - Resolve the actual `msg_mode`. If none is given, then `default_cmake_msg_mode` is used!
        resolve_msg_mode("${default_cmake_msg_mode}")

        # ---------------------------------------------------------------------------------------------- #
        
        # Format message label, acc. to the log level
        format_log_level_label("${log_level}" label)

        # List separator
        set(separator "${RSP_DEFAULT_LIST_SEPARATOR}")
        if (DEFINED INPUT_LIST_SEPARATOR)
            set(separator "${INPUT_LIST_SEPARATOR}")
        endif ()

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
        if (DEFINED INPUT_CONTEXT)
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

        # Assign to output variable, if requested and stop any further processing.
        if (DEFINED INPUT_OUTPUT)
            set("${INPUT_OUTPUT}" "${label}${formatted_output}")
            return(PROPAGATE "${INPUT_OUTPUT}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Finally, output the log message
        output(${formatted_output}
            "${msg_mode}"
            LABEL "${label}"
        )
    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Log formatting utils
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "format_log_level_label")

    #! format_log_level_label : Formats a label, acc. to specified log level
    #
    # @param <string> level     Log level
    # @param <variable> output  The output variable to assign result to
    #
    # @return
    #   output                  The formatted label
    #
    function(format_log_level_label level output)
        set(style_affix "_style")

        set("${EMERGENCY_LEVEL}${style_affix}" "${COLOR_BRIGHT_RED}${TEXT_BOLD}")
        set("${ALERT_LEVEL}${style_affix}" "${COLOR_BRIGHT_RED}${TEXT_BOLD}")
        set("${CRITICAL_LEVEL}${style_affix}" "${COLOR_RED}${TEXT_BOLD}")
        set("${ERROR_LEVEL}${style_affix}" "${COLOR_RED}${TEXT_BOLD}")
        set("${WARNING_LEVEL}${style_affix}" "${COLOR_YELLOW}${TEXT_BOLD}")
        set("${NOTICE_LEVEL}${style_affix}" "${COLOR_BRIGHT_BLUE}")
        set("${INFO_LEVEL}${style_affix}" "${COLOR_BLUE}")
        set("${DEBUG_LEVEL}${style_affix}" "${COLOR_WHITE}")

        # Abort if no style can be found for requested level
        if (NOT DEFINED "${level}${style_affix}")
            message(FATAL_ERROR "Unable to find style for log level: ${level}")
        endif ()

        # Apply evt. additional formatting of label...
        set(label "${level}")

        set("${output}" "${${level}${style_affix}}${label}${RESTORE}")

        return(PROPAGATE "${output}")
    endfunction()
endif ()

if (NOT COMMAND "format_log_message")

    #! format_log_message : Formats given log message, acc. to given log level
    #
    # @param <string> level         Log level
    # @param <string> message       The log message
    # @param <variable> output      The output variable to assign result to
    #
    # @return
    #   output                      The formatted message
    #
    function(format_log_message level message output)
        set(style_affix "_style")

        set("${EMERGENCY_LEVEL}${style_affix}" "${TEXT_BOLD}${TEXT_ITALIC}")
        set("${ALERT_LEVEL}${style_affix}" "${TEXT_BOLD}")
        set("${CRITICAL_LEVEL}${style_affix}" "${TEXT_BOLD}")
        set("${ERROR_LEVEL}${style_affix}" "")
        set("${WARNING_LEVEL}${style_affix}" "${TEXT_ITALIC}")
        set("${NOTICE_LEVEL}${style_affix}" "")
        set("${INFO_LEVEL}${style_affix}" "")
        set("${DEBUG_LEVEL}${style_affix}" "${TEXT_ITALIC}")

        # Abort if no style can be found for requested level
        if (NOT DEFINED "${level}${style_affix}")
            message(FATAL_ERROR "Unable to style message for log level: ${level}")
        endif ()

        # Apply evt. additional formatting of message...
        set(formatted "${message}")

        set("${output}" "${${level}${style_affix}}${formatted}${RESTORE}")

        return(PROPAGATE "${output}")
    endfunction()
endif ()


if (NOT COMMAND "format_log_context")

    #! format_log_context : Formats evt. context variables, acc. to log level
    #
    # @param <string> level         Log level
    # @param <list> context         List of variables
    # @param <variable> output      The output variable to assign result to
    #
    # @return
    #   output                      The formatted log context
    #
    function(format_log_context level context output)
        set(style_affix "_style")

        set("${EMERGENCY_LEVEL}${style_affix}" "")
        set("${ALERT_LEVEL}${style_affix}" "")
        set("${CRITICAL_LEVEL}${style_affix}" "")
        set("${ERROR_LEVEL}${style_affix}" "")
        set("${WARNING_LEVEL}${style_affix}" "")
        set("${NOTICE_LEVEL}${style_affix}" "")
        set("${INFO_LEVEL}${style_affix}" "")
        set("${DEBUG_LEVEL}${style_affix}" "")

        # Abort if no style can be found for requested level
        if (NOT DEFINED "${level}${style_affix}")
            message(FATAL_ERROR "Unable to style context for log level: ${level}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        set(indent "${RSP_LOG_INDENT}")
        set(buffer "")

        # ---------------------------------------------------------------------------------------------- #

        string(APPEND buffer "\n${indent}[")

        foreach (prop IN LISTS context)

            set(entry "${COLOR_BRIGHT_MAGENTA}${TEXT_ITALIC}${prop}${RESTORE} = ${${prop}}")

            string(REPEAT "${indent}" 2 i)
            string(APPEND buffer "\n${i}${entry}")
        endforeach ()

        string(APPEND buffer "\n${indent}]")

        set(formatted "${COLOR_MAGENTA}Context${RESTORE}: ${buffer}")

        # ---------------------------------------------------------------------------------------------- #

        set("${output}" "\n${indent}${${level}${style_affix}}${formatted}${RESTORE}")

        return(PROPAGATE "${output}")
    endfunction()
endif ()

if (NOT COMMAND "format_log_timestamp")

    #! format_log_timestamp : Formats current timestamp, acc. to given log level
    #
    # @param <string> level         Log level
    # @param <variable> output      The output variable to assign result to
    #
    # @return
    #   output                      The formatted timestamp
    #
    function(format_log_timestamp level output)
        set(style_affix "_style")

        set("${EMERGENCY_LEVEL}${style_affix}" "")
        set("${ALERT_LEVEL}${style_affix}" "")
        set("${CRITICAL_LEVEL}${style_affix}" "")
        set("${ERROR_LEVEL}${style_affix}" "")
        set("${WARNING_LEVEL}${style_affix}" "")
        set("${NOTICE_LEVEL}${style_affix}" "")
        set("${INFO_LEVEL}${style_affix}" "")
        set("${DEBUG_LEVEL}${style_affix}" "")

        # Abort if no style can be found for requested level
        if (NOT DEFINED "${level}${style_affix}")
            message(FATAL_ERROR "Unable to style timestamp for log level: ${level}")
        endif ()

        # Timestamp
        string(TIMESTAMP now "${RSP_LOG_TIMESTAMP_FORMAT}")
        set(formatted "${COLOR_MAGENTA}${TEXT_ITALIC}Timestamp${RESTORE}: ${now}")

        set("${output}" "\n${RSP_LOG_INDENT}${${level}${style_affix}}${formatted}${RESTORE}")

        return(PROPAGATE "${output}")
    endfunction()
endif ()