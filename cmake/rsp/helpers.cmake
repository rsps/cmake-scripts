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

if (NOT COMMAND "requires_arguments")

    #! requires_arguments : Ensures that specified arguments have been defined, fails otherwise
    #
    # Macro is intended to be used within a custom function, after `cmake_parse_arguments()` has
    # been used.
    #
    # @see https://cmake.org/cmake/help/latest/command/cmake_parse_arguments.html#cmake-parse-arguments
    # @see https://cmake.org/cmake/help/latest/command/if.html#defined
    #
    # @param <variable|string> input  The parsed arguments prefix
    # @param <list> required          List of required arguments
    #
    # @throws If required arguments are not defined
    #
    macro(requires_arguments input required)
        foreach (arg ${required})
            if (NOT DEFINED "${input}_${arg}")
                message(FATAL_ERROR "${arg} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()
    endmacro()
endif ()

if (NOT COMMAND "safeguard_properties")

    #! safeguard_properties : Invoke a "risky" callback whilst "safeguarding" properties
    #
    # Function copies the values of the specified properties, invokes the callback, and
    # restores the properties' values.
    #
    # Caution: This function does NOT prevent properties from being force-cached.
    # Environment variables are NOT prevented changed.
    #
    # Alternatively, consider using cmake's `block()`.
    #
    # @see https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#variables
    # @see https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#environment-variables
    # @see https://cmake.org/cmake/help/latest/command/block.html#block
    #
    # @param [CALLBACK <command>]           Risky command or macro to be invoked.
    # @param [PROPERTIES <variable>...]     One or more properties to safeguard.
    #
    # @return
    #       [PROPERTIES <variable>...]      Restored properties
    #
    function(safeguard_properties)
        set(options "") # N/A
        set(oneValueArgs CALLBACK)
        set(multiValueArgs PROPERTIES)

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
        requires_arguments(INPUT "CALLBACK;PROPERTIES")

        # ---------------------------------------------------------------------------------------------- #

        # Abort if callback not defined
        if (NOT COMMAND "${INPUT_CALLBACK}")
            message(FATAL_ERROR "Callback \"${INPUT_CALLBACK}()\" does not exist")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        set(prefix "original_")

        # Copy each provided property
        foreach (prop ${INPUT_PROPERTIES})
            message(VERBOSE "Safeguarding: ${prop}, original value: ${${prop}}")

            set("${prefix}${prop}" "${${prop}}")
        endforeach ()

        # ---------------------------------------------------------------------------------------------- #

        # Invoke the risky callback
        message(VERBOSE "Invoking risky callback: ${INPUT_CALLBACK}")
        cmake_language(CALL "${INPUT_CALLBACK}")

        # ---------------------------------------------------------------------------------------------- #

        # Restore each provided property
        foreach (prop ${INPUT_PROPERTIES})
            message(VERBOSE "Restoring: ${prop} from: ${${prop}}, to original value: ${${prefix}${prop}}")

            # Ensure that property is set on parent scope
            set("${prop}" "${${prefix}${prop}}" PARENT_SCOPE)
        endforeach ()
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