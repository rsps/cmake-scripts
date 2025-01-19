# -------------------------------------------------------------------------------------------------------------- #
# Misc. helper functions
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/helpers module included")

if (NOT COMMAND "fail_in_source_build")

    #! fail_in_source_build : Fails when building project in the source directory
    #
    # @throws
    #
    function(fail_in_source_build)
        get_filename_component(sourceDir "${CMAKE_SOURCE_DIR}" REALPATH)
        get_filename_component(binDir "${CMAKE_BINARY_DIR}" REALPATH)

        if (${sourceDir} STREQUAL ${binDir})
            message(FATAL_ERROR "In-source builds are forbidden!")
        endif()
    endfunction()
endif ()

if (NOT COMMAND "extract_value")

    #! extract_value : Extracts variable value
    #
    # If given key is a value, then the value will be assigned
    # to the output variable.
    #
    # @param <variable> output  The variable to assign extracted value to
    # @param <mixed> key        The target key
    #
    # @return
    #     output                The extracted value
    #
    function(extract_value output key)

        set("${output}" "${key}")

        if (DEFINED ${key})
            set("${output}" "${${key}}")
        endif ()

        return(PROPAGATE "${output}")
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