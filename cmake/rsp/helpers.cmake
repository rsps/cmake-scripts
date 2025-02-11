# -------------------------------------------------------------------------------------------------------------- #
# Misc. helper functions
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/helpers module included")

include("rsp/helpers/types")

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
    # @param <list> required                List of required arguments
    # @param <variable|string> prefix       The parsed input arguments prefix
    #                                       used in your cmake_parse_arguments() call.
    #
    # @throws If required arguments are not defined
    #
    macro(requires_arguments required prefix)
        # Note: the "prefix" parameter cannot be made optional for this macro.
        # It is unsafe to rely on any ${ARGV} in this context, ...
        # @see https://cmake.org/cmake/help/latest/command/macro.html#argument-caveats

        # Append "_" to the prefix, if given.
        # @see https://cmake.org/cmake/help/latest/command/cmake_parse_arguments.html#cmake-parse-arguments
        set(resolved_prefix "${prefix}")
        if(NOT ${prefix} EQUAL "")
            set(resolved_prefix "${prefix}_")
        endif ()

        foreach (arg ${required})
            if (NOT DEFINED "${resolved_prefix}${arg}")
                message(FATAL_ERROR "${arg} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()
    endmacro()
endif ()

if (NOT COMMAND "safeguard_properties")

    #! safeguard_properties : Invoke a "risky" callback whilst "safeguarding" properties
    #
    # Macro copies the values of the specified properties, invokes the callback, and
    # restores the properties' original values.
    #
    # Caution: This macro does NOT prevent properties from being force-cached.
    # Environment variables are NOT prevented changed.
    #
    # Alternatively, consider using cmake's `block()` or a function with its own variable
    # scope.
    #
    # @see https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#variables
    # @see https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#environment-variables
    # @see https://cmake.org/cmake/help/latest/command/block.html#block
    #
    # @param <command> callback     Risky command or macro to be invoked.
    # @param <list> properties      List of variable names - variables to safeguard from
    #                               undesired value changes.
    #
    macro(safeguard_properties callback properties)
        set(prefix "original_")

        # Copy each provided property
        foreach (prop ${properties})
            message(VERBOSE "Safeguarding: ${prop}, original value: ${${prop}}")

            set("${prefix}${prop}" "${${prop}}")
        endforeach ()

        # ---------------------------------------------------------------------------------------------- #

        # Invoke the risky callback
        message(VERBOSE "Invoking risky callback: ${callback}")
        cmake_language(CALL "${callback}")

        # ---------------------------------------------------------------------------------------------- #

        # Restore each provided property
        foreach (prop ${properties})
            message(VERBOSE "Restoring: ${prop} from: ${${prop}}, to original value: ${${prefix}${prop}}")

            # Restore property's original value
            set("${prop}" "${${prefix}${prop}}")
        endforeach ()
    endmacro()
endif ()
