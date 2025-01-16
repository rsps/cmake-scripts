# -------------------------------------------------------------------------------------------------------------- #
# Misc. helper functions
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/helpers module included")

if (NOT COMMAND "fail_when_build_in_source")

    #! fail_when_build_in_source : Fails when building project in the source directory
    #
    # @throws
    #
    function(fail_when_build_in_source)
        if (${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
            message(FATAL_ERROR "In-source builds are forbidden!")
        endif()
    endfunction()
endif ()

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