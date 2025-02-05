# -------------------------------------------------------------------------------------------------------------- #
# Logging utilities
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/logging/utils module included")

include("rsp/output")

# -------------------------------------------------------------------------------------------------------------- #
# Defaults
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
    set(RSP_LOG_TIMESTAMP_FORMAT "%Y-%m-%d %H:%M:%S.%f" CACHE STRING " RSP log timestamp format")
endif ()

if (NOT DEFINED RSP_LOG_TIMESTAMP_UTC)

    # Use UTC or local time...
    set(RSP_LOG_TIMESTAMP_UTC false CACHE BOOL " RSP log timestamp UTC state (true if UTC, false if local)")
endif ()

if (NOT DEFINED RSP_LOG_INDENT)

    # Indentation for log context, timestamp,...etc
    set(RSP_LOG_INDENT "   " CACHE STRING " RSP ident for log context, timestamp...etc")
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Functions & Macros
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "resolve_cmake_message_mode")

    #! resolve_cmake_message_mode : Resolves the CMake message mode acc. to requested
    # PSR log level.
    #
    # WARNING: Macro is intended to be used internally within misc. log
    # functions.
    #
    # @see https://cmake.org/cmake/help/latest/command/message.html#general-messages
    # @see rsp/output/utils::resolve_msg_mode
    #
    # @internal
    #
    macro(resolve_cmake_message_mode)
        # Resolve CMake's message mode, acc. to specified log level.
        set(default_cmake_msg_mode "NOTICE")

        foreach (lvl IN LISTS RSP_LOG_LEVELS_CMAKE)
            string(REPLACE " " ";" parts "${lvl}")

            # psr = PSR log level, value = CMake message mode
            list(GET parts 0 psr)
            list(GET parts 1 msg_mode_cmake)

            if ("${psr}" STREQUAL "${log_level}")
                message(VERBOSE "Mapping ${log_level} level to cmake message mode ${msg_mode_cmake}")

                set(default_cmake_msg_mode "${msg_mode_cmake}")
                unset(psr)
                unset(msg_mode_cmake)

                break()
            endif ()
        endforeach ()

        # - Resolve the actual `msg_mode`. If none is given, then `default_cmake_msg_mode` is used!
        resolve_msg_mode("${default_cmake_msg_mode}")
    endmacro()
endif ()

if (NOT COMMAND "format_log_level_label")

    #! format_log_level_label : Formats a label, acc. to specified log level
    #
    # @param <string> level     Log level
    # @param <variable> output  The output variable to assign result to
    #
    # @return
    #       output                  The formatted label
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
    #       output                      The formatted message
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
    #       output                      The formatted log context
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
    #       output                      The formatted timestamp
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

        # Obtain current timestamp
        if (RSP_LOG_TIMESTAMP_UTC)
            string(TIMESTAMP now "${RSP_LOG_TIMESTAMP_FORMAT}" UTC)
        else()
            string(TIMESTAMP now "${RSP_LOG_TIMESTAMP_FORMAT}")
        endif ()

        # Format output...
        set(formatted "${COLOR_MAGENTA}${TEXT_ITALIC}Timestamp${RESTORE}: ${now}")

        set("${output}" "\n${RSP_LOG_INDENT}${${level}${style_affix}}${formatted}${RESTORE}")

        return(PROPAGATE "${output}")
    endfunction()
endif ()
