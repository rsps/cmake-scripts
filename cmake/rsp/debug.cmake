# -------------------------------------------------------------------------------------------------------------- #
# Debug utilities functions
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/debug module included")

include("rsp/output/utils")

if (NOT COMMAND "dump")

    #! dump : Outputs given variables' name and value
    #
    # @param ... Variables to output
    #
    function(dump)
        foreach (var ${ARGN})
            message("${var} = ${${var}}")
        endforeach ()

        # Output as warning so that the developer is able to see call stack!
        message(WARNING "   ${CMAKE_CURRENT_FUNCTION}() called from ${CMAKE_CURRENT_LIST_FILE}")
    endfunction()
endif ()

if (NOT COMMAND "dd")

    #! dump and die: Outputs given variables' name and value and stops build
    #
    # @param ... Variables to output
    #
    function(dd)
        foreach (var ${ARGN})
            message("${var} = ${${var}}")
        endforeach ()

        # Output as fatal error to ensure that build stops.
        message(FATAL_ERROR "   ${CMAKE_CURRENT_FUNCTION}() called from ${CMAKE_CURRENT_LIST_FILE}")
    endfunction()
endif ()

if(NOT COMMAND "build_info")

    #! build_info : Output build information to stdout or stderr (Cmake's message type specific)
    #
    # @see https://cmake.org/cmake/help/latest/command/message.html
    #
    # @param [<mode>]                           Option - Cmake's message type. Defaults to NOTICE, when not specified.
    # @param [OUTPUT <variable>]                Optional - If specified, message is assigned to output variable instead of
    #                                           being printed to stdout or stderr.
    #
    # @return
    #       [OUTPUT]                            The resulting output variable, if OUTPUT was specified.
    #
    function(build_info)
        set(options "${RSP_CMAKE_MESSAGE_MODES}")
        set(oneValueArgs OUTPUT)
        set(multiValueArgs "")

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # ---------------------------------------------------------------------------------------------- #

        # Message mode
        resolve_msg_mode("NOTICE")

        # ---------------------------------------------------------------------------------------------- #

        set(info_list
            # Build Type
            # @see https://cmake.org/cmake/help/latest/variable/CMAKE_BUILD_TYPE.html
            "Type|${CMAKE_BUILD_TYPE}"

            # Library Type (NOTE: LIB_TYPE is NOT a predefined cmake variable)
            "Library Type|${LIB_TYPE}"

            # Compiler flags
            "Compiler flags|${CMAKE_CXX_COMPILE_FLAGS}"

            # Compiler cxx debug flags
            "Compiler cxx debug flags|${CMAKE_CXX_FLAGS_DEBUG}"

            # Compiler cxx release flags
            "Compiler cxx release flags|${CMAKE_CXX_FLAGS_RELEASE}"

            # Compiler cxx min size flags
            "Compiler cxx min size flags|${CMAKE_CXX_FLAGS_MINSIZEREL}"

            # Compiler cxx flags
            "Compiler cxx flags|${CMAKE_CXX_FLAGS}"
        )

        # ---------------------------------------------------------------------------------------------- #

        set(buffer "")

        foreach (item IN LISTS info_list)
            string(REPLACE "|" ";" parts "${item}")
            list(GET parts 0 label)
            list(GET parts 1 value)

            list(APPEND buffer "${COLOR_MAGENTA}${label}:${RESTORE} ${value}")
        endforeach ()

        # ---------------------------------------------------------------------------------------------- #

        # Convert list to a string with newlines...
        string(REPLACE ";" "\n" buffer "${buffer}")

        # Attempt to keep the formatting - see details in rsp/output::output()
        string(ASCII 13 CR)
        set(formatted_output "${CR}${COLOR_BRIGHT_MAGENTA}build info:${RESTORE}\n${buffer}")
        string(REPLACE "\n" "\n " formatted_output "${formatted_output}")

        # ---------------------------------------------------------------------------------------------- #

        # Assign to output variable, if requested and stop any further processing.
        if (DEFINED INPUT_OUTPUT)
            set("${INPUT_OUTPUT}" "${formatted_output}")
            return(PROPAGATE "${INPUT_OUTPUT}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        message(${msg_mode} "${formatted_output}")
    endfunction()
endif ()
