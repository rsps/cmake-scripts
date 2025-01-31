# -------------------------------------------------------------------------------------------------------------- #
# Output Utils
# -------------------------------------------------------------------------------------------------------------- #

# -------------------------------------------------------------------------------------------------------------- #
# Message Modes
# -------------------------------------------------------------------------------------------------------------- #

if (NOT DEFINED RSP_CMAKE_MESSAGE_MODES)

    # CMake's message modes / types
    #
    # @see https://cmake.org/cmake/help/latest/command/message.html#general-messages
    #
    set(RSP_CMAKE_MESSAGE_MODES
        TRACE
        DEBUG
        VERBOSE
        STATUS
        NOTICE
        DEPRECATION
        AUTHOR_WARNING
        WARNING
        SEND_ERROR
        FATAL_ERROR

        CACHE STRING " RSP cmake message modes / types"
    )
endif ()

if (NOT COMMAND "resolve_msg_mode")

    #! resolve_msg_mode : Resolves requested CMake message mode
    #
    # WARNING: Macro is intended to be used internally within misc. output
    # functions. It sets a `msg_mode`, based on the option requested, or
    # defaults to `NOTICE`.
    #
    # @see https://cmake.org/cmake/help/latest/command/message.html#general-messages
    # @see RSP_CMAKE_MESSAGE_MODES
    #
    # @internal
    #
    macro(resolve_msg_mode)
        set(msg_mode "NOTICE")

        foreach (m IN LISTS RSP_CMAKE_MESSAGE_MODES)
            if (INPUT_${m})
                message(VERBOSE "Message mode set to: ${m}")

                set(msg_mode "${m}")
                break()
            endif ()
        endforeach ()
    endmacro()
endif ()