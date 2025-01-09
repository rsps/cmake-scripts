# -------------------------------------------------------------------------------------------------------------- #
# Misc. helper functions
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

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