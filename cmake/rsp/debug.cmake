# -------------------------------------------------------------------------------------------------------------- #
# Debug utilities functions
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/debug module included")

include("rsp/output/utils")
include("rsp/helpers")

if (NOT COMMAND "dump")

    #! dump : Outputs given variables' name and value
    #
    # Note: function outputs using cmake's WARNING message mode
    #
    # This function is inspired by Symfony's `dump()`, (copyright Fabien Potencier - MIT License)
    # @see https://symfony.com/doc/current/components/var_dumper.html
    #
    # @see https://cmake.org/cmake/help/latest/command/message.html#general-messages
    # @see var_dump()
    #
    # @param ... Variables to output
    #
    function(dump)
        var_dump(OUTPUT output PROPERTIES ${ARGN})

        # Attempt to keep the formatting - see details in rsp/output::output()
        string(ASCII 13 CR)
        set(formatted_output "${CR}${COLOR_WHITE}dump:${RESTORE}\n${output}")
        string(REPLACE "\n" "\n " formatted_output "${formatted_output}")

        message(WARNING "${formatted_output}")
    endfunction()
endif ()

if (NOT COMMAND "dd")

    #! dd: Outputs given variables' name and value and stops build (dump and die)
    #
    # Note: function outputs using cmake's FATAL_ERROR message mode
    #
    # This function is inspired by Symfony's `dd()`, (copyright Fabien Potencier - MIT License)
    # @see https://symfony.com/doc/current/components/var_dumper.html
    #
    # @see https://cmake.org/cmake/help/latest/command/message.html#general-messages
    # @see var_dump()
    #
    # @param ... Variables to output
    #
    function(dd)
        var_dump(OUTPUT output PROPERTIES ${ARGN})

        # Attempt to keep the formatting - see details in rsp/output::output()
        string(ASCII 13 CR)
        set(formatted_output "${CR}${COLOR_WHITE}dd:${RESTORE}\n${output}")
        string(REPLACE "\n" "\n " formatted_output "${formatted_output}")

        message(FATAL_ERROR "${formatted_output}")
    endfunction()
endif ()

if (NOT COMMAND "var_dump")

    #! var_dump : Outputs human-readable information about given properties
    #
    # This function is inspired by Symfony's var dumper component, (copyright Fabien Potencier - MIT License)
    # @see https://symfony.com/doc/current/components/var_dumper.html
    #
    # @param [OUTPUT <variable>]            Optional - If specified, information is assigned to output variable
    #                                       instead of being printed to stderr.
    # @param [PROPERTIES <variable>...]     One or more variables to dump information about.
    # @param [WITHOUT_NAMES]                Option, if given then property names are omitted from the output
    # @param [IGNORE_LIST]                  Option, if specified the variable values of the type "list" are
    #                                       treated as "string".
    #
    # @return
    #       [OUTPUT]                       The resulting output variable, if OUTPUT was specified.
    #
    function(var_dump)
        set(options WITHOUT_NAMES IGNORE_LIST)
        set(oneValueArgs OUTPUT)
        set(multiValueArgs PROPERTIES)

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
        requires_arguments("PROPERTIES" INPUT)

        # ---------------------------------------------------------------------------------------------- #

        set(buffer "")

        foreach (key IN LISTS INPUT_PROPERTIES)
            # Attempt to resolve value and it's datatype
            set(value "${${key}}")
            get_type("${key}" type)

            # ---------------------------------------------------------------------------------------------- #

            set(tmp_list_separator "<!list!>")
            if (INPUT_IGNORE_LIST AND type STREQUAL "list")
                # Debug
                #message("Ignoring list: ${key} | ${value}")

                set(type "string")
                string(REPLACE ";" "${tmp_list_separator}" value "${value}")
            endif ()

            # ---------------------------------------------------------------------------------------------- #

            # If  key is defined as an environment variable, the value
            # must be obtained via ENV{}.
            if (DEFINED ENV{${key}})
                set(value "$ENV{${key}}")
                get_type("${value}" type)
            elseif (NOT DEFINED ${key} AND type STREQUAL "string")
                # We ONLY deal with variables, meaning that if key isn't
                # defined, and the type is determined to be a string,
                # then we must assume that it's an undefined property!

                set(type "${COLOR_RED}${TEXT_ITALIC}undefined${TEXT_ITALIC_RESTORE}${COLOR_DEFAULT}")
            endif ()

            # Format the value...
            if (type STREQUAL "string")
                # Resolve string length, by ensuring to count the length of
                # the original value, without list separator replacement.
                set(tmp_str "${value}")
                string(REPLACE "${tmp_list_separator}" ";" tmp_str "${tmp_str}")
                string(LENGTH "${tmp_str}" str_length)

                set(type "${type} ${str_length}")
                set(value "${COLOR_GREEN}\"${value}\"${RESTORE}")
            elseif (type STREQUAL "int" OR type STREQUAL "float")
                set(value "${COLOR_BRIGHT_BLUE}${value}${RESTORE}")
            elseif (type STREQUAL "bool")
                set(value "${COLOR_CYAN}${value}${RESTORE}")
            elseif (type STREQUAL "command")
                set(value "${COLOR_BLUE}${key}()${RESTORE}")
            elseif (type STREQUAL "list")
                list(LENGTH value lst_length)
                set(type "${type} ${lst_length}")
                set(list_buffer "")

                set(i 0) # index counter
                foreach (item IN LISTS value)
                    # Get property information about the "item", but without key name.
                    # Also, ensure to ignore values of the type "list", to avoid
                    # strange behaviour (caused by cmake's variable scopes...)
                    set("list_item_${i}" "${item}")
                    var_dump(OUTPUT list_item WITHOUT_NAMES IGNORE_LIST PROPERTIES "list_item_${i}")

                    # Append to list buffer and increment the "index" counter.
                    list(APPEND list_buffer "${COLOR_MAGENTA}${i}:${RESTORE} ${list_item}")
                    math(EXPR i "${i}+1" OUTPUT_FORMAT DECIMAL)
                endforeach ()

                string(REPLACE ";" "\n   " list_buffer "${list_buffer}")
                set(value "[ \n   ${list_buffer}\n]")
            endif ()

            # Mark the key as cached, if needed...
            if(DEFINED CACHE{${key}})
                set(type "${type}, ${TEXT_ITALIC}${TEXT_BOLD}cached${TEXT_BOLD_RESTORE}${TEXT_ITALIC_RESTORE}")
            endif ()

            # Mark the key an environment variable, if needed...
            if(DEFINED ENV{${key}})
                set(type "${type}, ${TEXT_ITALIC}${TEXT_BOLD}ENV${TEXT_BOLD_RESTORE}${TEXT_ITALIC_RESTORE}")
            endif ()

            # The output format: <key> = (<type>) <value>
            # Unless key is omitted.
            set(formatted_key "${COLOR_BRIGHT_MAGENTA}${key}${RESTORE} = ")
            if (INPUT_WITHOUT_NAMES)
                set(formatted_key "")
            endif ()

            list(APPEND buffer "${formatted_key}${COLOR_WHITE}(${type}${COLOR_WHITE})${RESTORE} ${value}")
        endforeach ()

        # ---------------------------------------------------------------------------------------------- #

        string(REPLACE ";" "\n" buffer "${buffer}")

        # Restore list value (as a string) if needed.
        if (INPUT_IGNORE_LIST)
            string(REPLACE "${tmp_list_separator}" ";" buffer "${buffer}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        # Assign to output variable, if requested and stop any further processing.
        if (DEFINED INPUT_OUTPUT)
            set("${INPUT_OUTPUT}" "${buffer}")
            return(PROPAGATE "${INPUT_OUTPUT}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        message(NOTICE "${buffer}")

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
