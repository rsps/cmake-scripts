# -------------------------------------------------------------------------------------------------------------- #
# Types
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/helpers/types module included")

if (NOT COMMAND "is_int")

    #! is_int : Determine if value is an integer
    #
    # @param <mixed> target_value   The value in question
    # @param <variable> output      The variable to assign extracted result to
    #
    # @return
    #     output                True or false
    #
    function(is_int target_value output)
        set("${output}" false)
        _resolve_target_value()

        if (target_value MATCHES "^([\-\+]?)([0-9]+)$")
            set("${output}" true)
        endif ()

        return(PROPAGATE "${output}")
    endfunction()
endif ()

if (NOT COMMAND "is_float")

    #! is_float : Determine if value is a float
    #
    # @param <mixed> target_value   The value in question
    # @param <variable> output      The variable to assign extracted result to
    #
    # @return
    #     output                True or false
    #
    function(is_float target_value output)
        set("${output}" false)
        _resolve_target_value()

        if (target_value MATCHES "^([\-\+]?)([0-9]+)\.([0-9]+)$")
            set("${output}" true)
        endif ()

        return(PROPAGATE "${output}")
    endfunction()
endif ()

if (NOT COMMAND "is_numeric")

    #! is_numeric : Determine if value is numeric
    #
    # @param <mixed> target_value   The value in question
    # @param <variable> output      The variable to assign extracted result to
    #
    # @return
    #     output                True or false
    #
    function(is_numeric target_value output)
        set("${output}" false)
        _resolve_target_value()

        if (target_value MATCHES "^([\-\+]?)([0-9]+)$" OR target_value MATCHES  "^([\-\+]?)([0-9]+)\.([0-9]+)$")
            set("${output}" true)
        endif ()

        return(PROPAGATE "${output}")
    endfunction()
endif ()

if (NOT COMMAND "is_bool")

    #! is_bool : Determine if value is a boolean
    #
    # Caution: Function only recognises `true` and `false` as
    # boolean values.
    #
    # @see is_bool_like()
    #
    # @param <mixed> target_value   The value in question
    # @param <variable> output      The variable to assign extracted result to
    #
    # @return
    #     output                True or false
    #
    function(is_bool target_value output)
        set("${output}" false)
        _resolve_target_value()

        set(accepted "true;false")
        string(TOLOWER "${target_value}" target_value)

        if (target_value IN_LIST accepted)
            set("${output}" true)
        endif ()

        return(PROPAGATE "${output}")
    endfunction()
endif ()

if (NOT COMMAND "is_bool_like")

    #! is_bool_like : Determine if value is a boolean
    #
    # Caution: Function recognises all values that cmake can
    # evaluate as truthy or falsy.
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#constant
    # @see https://cmake.org/cmake/help/latest/command/if.html#logic-operators
    #
    # @param <mixed> target_value   The value in question
    # @param <variable> output      The variable to assign extracted result to
    #
    # @return
    #     output                True or false
    #
    function(is_bool_like target_value output)
        set("${output}" false)
        _resolve_target_value()

        # ...a non-zero number (including floating point numbers) is also considered
        # to be boolean (true).
        # NOTE: negative values DO NOT evaluate to false!
        is_numeric("${target_value}" is_num)
        if (is_num AND "${target_value}" GREATER_EQUAL 0)
            set("${output}" true)
            return(PROPAGATE "${output}")
        endif ()

        set(accepted "on;yes;true;y;off;0;no;false;n;ignore;notfound")
        string(TOLOWER "${target_value}" target_value)
        string(LENGTH "${target_value}" length)

        if (target_value IN_LIST accepted OR length EQUAL 0 OR target_value MATCHES "-notfound$")
            set("${output}" true)
        endif ()

        return(PROPAGATE "${output}")
    endfunction()
endif ()

if (NOT COMMAND "is_list")

    #! is_list : Determine if value is a list of values
    #
    # @see https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#cmake-language-lists
    # @see https://cmake.org/cmake/help/latest/command/list.html
    #
    # @param <mixed> target_value   The value in question
    # @param <variable> output      The variable to assign extracted result to
    #
    # @return
    #     output                True or false
    #
    function(is_list target_value output)
        set("${output}" false)
        _resolve_target_value()

        string(FIND "${target_value}" ";" has_separator)
        list(LENGTH target_value length)

        if (NOT has_separator EQUAL -1 AND length GREATER 0)
            set("${output}" true)
        endif ()

        return(PROPAGATE "${output}")
    endfunction()
endif ()

if (NOT COMMAND "is_command")

    #! is_command : Determine if value is command, macro or function
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#command
    #
    # @param <mixed> target_value   The value in question
    # @param <variable> output      The variable to assign extracted result to
    #
    # @return
    #     output                True or false
    #
    function(is_command target_value output)
        set("${output}" false)
        _resolve_target_value()

        if (COMMAND "${target_value}")
            set("${output}" true)
        endif ()

        return(PROPAGATE "${output}")
    endfunction()
endif ()

if (NOT COMMAND "is_string")

    #! is_string : Determine if value is a string
    #
    # Warning: This function evaluates only to true, if given value
    # is:
    #   - not numeric
    #   - not a boolean (true or false)
    #   - not a list (semicolon separated list)
    #   - not a command
    #
    # @see https://cmake.org/cmake/help/latest/manual/cmake-language.7.html#variables
    # @see is_numeric()
    # @see is_bool()
    # @see is_list()
    # @see is_command()
    #
    # @param <mixed> target_value   The value in question
    # @param <variable> output      The variable to assign extracted result to
    #
    # @return
    #     output                True or false
    #
    function(is_string target_value output)
        set("${output}" false)
        _resolve_target_value()

        is_numeric("${target_value}" num)
        is_bool("${target_value}" bool)
        is_list("${target_value}" lst)
        is_command("${target_value}" cmd)

        if (NOT num
            AND NOT bool
            AND NOT lst
            AND NOT cmd
        )
            set("${output}" true)
        endif ()

        return(PROPAGATE "${output}")
    endfunction()
endif ()

if (NOT COMMAND "get_type")

    #! get_type : Determine the type of given value
    #
    # @see is_int()
    # @see is_float()
    # @see is_bool()
    # @see is_list()
    # @see is_command()
    # @see is_string()
    #
    # @param <mixed> target_value   The value in question
    # @param <variable> output      The variable to assign extracted result to
    #
    # @return
    #       output              String representation of the type (int, float, bool, list, command, or string).
    # @throws                   If unable to determine target value's type
    #
    #
    function(get_type target_value output)
        set("${output}" "undefined")
        _resolve_target_value()

        # ---------------------------------------------------------------------------------------------- #

        is_string("${target_value}" str)
        if (str)
            set("${output}" "string")
            return(PROPAGATE "${output}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        is_int("${target_value}" int)
        if (int)
            set("${output}" "int")
            return(PROPAGATE "${output}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        is_float("${target_value}" float)
        if (float)
            set("${output}" "float")
            return(PROPAGATE "${output}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        is_bool("${target_value}" bool)
        if (bool)
            set("${output}" "bool")
            return(PROPAGATE "${output}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        is_list("${target_value}" lst)
        if (lst)
            set("${output}" "list")
            return(PROPAGATE "${output}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        is_command("${target_value}" cmd)
        if (cmd)
            set("${output}" "command")
            return(PROPAGATE "${output}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #
        # Fail in case that the type cannot be determined!

        message(FATAL_ERROR "Unable to determine type of target value: ${target_value}")
    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Internals
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "_resolve_target_value")

    #! _resolve_target_value : Resolves target value
    #
    # Macro (re)sets the `target_value`, if its value is a defined
    # variable.
    #
    # @internal
    #
    macro(_resolve_target_value)
        # Resolve "value" from variable
        if (DEFINED "${target_value}")
            set(target_value "${${target_value}}")
        endif ()
    endmacro()
endif ()