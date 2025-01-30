# -------------------------------------------------------------------------------------------------------------- #
# ANSI utilities
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/output/ansi module included")

if (NOT DEFINED RSP_IS_ANSI_ENABLED)

    # State that determines if ANSI is enabled or not
    #
    # @internal
    #
    set(RSP_IS_ANSI_ENABLED false)
endif ()

if (NOT DEFINED RSP_DEFAULT_ESCAPE_CHARACTER)

    # The default escape character to be used for
    # defining an ANSI escape sequence.
    #
    # @see ansi_escape_sequence()
    #
    string(ASCII 27 RSP_DEFAULT_ESCAPE_CHARACTER)
endif ()

if (NOT DEFINED RSP_ANSI_PRESET)

    # List of predefined variable names and ANSI codes
    #
    # @see https://en.wikipedia.org/wiki/ANSI_escape_code#Select_Graphic_Rendition_parameters
    # @see disable_ansi()
    # @see ansi_sgr()
    #
    # Format:
    #   <variable> <code>[|<code>]...
    #
    set(RSP_ANSI_PRESET
        # Reset / Restore
        "RESTORE 0"

        # Demo style
        # "MY_STYLE 1|3|4|9|31|47"

        # Text
        "TEXT_BOLD 1"
        "TEXT_BOLD_RESTORE 22"

        "TEXT_DIM 2"
        "TEXT_DIM_RESTORE 22"

        "TEXT_ITALIC 3"
        "TEXT_ITALIC_RESTORE 23"

        "TEXT_UNDERLINE 4"
        "TEXT_UNDERLINE_RESTORE 24"

        "TEXT_BLINK 5"
        "TEXT_BLINK_RESTORE 25"

        "TEXT_INVERSE 7"
        "TEXT_INVERSE_RESTORE 27"

        "TEXT_HIDDEN 8"
        "TEXT_HIDDEN_RESTORE 28"

        "TEXT_STRIKETHROUGH 9"
        "TEXT_STRIKETHROUGH_RESTORE 29"

        # Colours
        "COLOR_BLACK 30"
        "COLOR_BG_BLACK 40"
        "COLOR_BRIGHT_BLACK 90"
        "COLOR_BRIGHT_BG_BLACK 100"

        "COLOR_RED 31"
        "COLOR_BG_RED 41"
        "COLOR_BRIGHT_RED 91"
        "COLOR_BRIGHT_BG_RED 101"

        "COLOR_GREEN 32"
        "COLOR_BG_GREEN 42"
        "COLOR_BRIGHT_GREEN 92"
        "COLOR_BRIGHT_BG_GREEN 102"

        "COLOR_YELLOW 33"
        "COLOR_BG_YELLOW 43"
        "COLOR_BRIGHT_YELLOW 93"
        "COLOR_BRIGHT_BG_YELLOW 103"

        "COLOR_BLUE 34"
        "COLOR_BG_BLUE 44"
        "COLOR_BRIGHT_BLUE 94"
        "COLOR_BRIGHT_BG_BLUE 104"

        "COLOR_MAGENTA 35"
        "COLOR_BG_MAGENTA 45"
        "COLOR_BRIGHT_MAGENTA 95"
        "COLOR_BRIGHT_BG_MAGENTA 105"

        "COLOR_CYAN 36"
        "COLOR_BG_CYAN 46"
        "COLOR_BRIGHT_CYAN 96"
        "COLOR_BRIGHT_BG_CYAN 106"

        "COLOR_WHITE 37"
        "COLOR_BG_WHITE 47"
        "COLOR_BRIGHT_WHITE 97"
        "COLOR_BRIGHT_BG_WHITE 107"

        "COLOR_DEFAULT 39"
        "COLOR_BG_DEFAULT 49"
    )
endif ()

if (NOT COMMAND "enable_ansi")

    #! enable_ansi : Defines a series variables containing ansi escape sequences
    #
    # @see RSP_ANSI_PRESET
    # @see disable_ansi()
    #
    # @param [PRESET <list>]        Optional - List that defines variable names and
    #                               ANSI codes. Defaults to RSP_ANSI_PRESET.
    #
    function(enable_ansi)
        set(multiValueArgs PRESET)
        cmake_parse_arguments(INPUT "" "" "${multiValueArgs}" ${ARGN})

        # ---------------------------------------------------------------------------------------------- #
        # Resolve optional arguments

        # Use RSP ANSI preset, if none given
        if (NOT DEFINED INPUT_PRESET)
            set(INPUT_PRESET "${RSP_ANSI_PRESET}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        foreach(item IN LISTS INPUT_PRESET)

            string(REPLACE " " ";" parts "${item}")
            list(GET parts 0 name)
            list(GET parts 1 value)

            # Replace evt. "|" to semicolons to allow multiple codes
            string(REPLACE "|" ";" value "${value}")

            # Debug
            # dump(name value)

            ansi_sgr(OUTPUT sequence CODE "${value}")

            set("${name}" "${sequence}" PARENT_SCOPE)
        endforeach()

        # ---------------------------------------------------------------------------------------------- #

        # Change state
        set(RSP_IS_ANSI_ENABLED true PARENT_SCOPE)
    endfunction()
endif ()

if (NOT COMMAND "disable_ansi")

    #! enable_ansi : Unsets the variables containing ansi escape sequences
    #
    # @see RSP_ANSI_PRESET
    # @see enable_ansi()
    #
    # @param [PRESET <list>]        Optional - List that defines variable names and
    #                               ANSI codes. Defaults to RSP_ANSI_PRESET.
    #
    function(disable_ansi)
        set(multiValueArgs PRESET)
        cmake_parse_arguments(INPUT "" "" "${multiValueArgs}" ${ARGN})

        # ---------------------------------------------------------------------------------------------- #
        # Resolve optional arguments

        # Use RSP ANSI preset, if none given
        if (NOT DEFINED INPUT_PRESET)
            set(INPUT_PRESET "${RSP_ANSI_PRESET}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        foreach(item IN LISTS INPUT_PRESET)

            string(REPLACE " " ";" parts "${item}")
            list(GET parts 0 name)

            # Debug
            # dump(name value)

            unset("${name}" PARENT_SCOPE)
        endforeach()

        # ---------------------------------------------------------------------------------------------- #

        # Change state
        set(RSP_IS_ANSI_ENABLED false PARENT_SCOPE)
    endfunction()
endif ()

if (NOT COMMAND "ansi_sgr")

    #! ansi_sgr : Define an "Select Graphic Rendition (SGR)" ansi control sequence
    #
    # @see https://en.wikipedia.org/wiki/ANSI_escape_code#Select_Graphic_Rendition_parameters
    # @see ansi_escape_sequence()
    #
    # @example
    #       ansi_sgr(OUTPUT MY_STYLE CODE "1;31")
    #       ansi_sgr(OUTPUT RESTORE CODE "0")
    #       message("${MY_STYLE}Title:${RESTORE} John Doe's Adventures")
    #
    # @param OUTPUT <variable>      The output variable to assign escape sequence to.
    # @param CODE <string>          The control sequence.
    #
    # @return
    #     [OUTPUT]                  The control sequence
    #
    function(ansi_sgr)
        set(oneValueArgs OUTPUT)
        set(multiValueArgs CODE)

        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
        requires_arguments("OUTPUT;CODE" INPUT)

        ansi_escape_sequence(OUTPUT "${INPUT_OUTPUT}" CODE "[${INPUT_CODE}m")

        return(PROPAGATE "${INPUT_OUTPUT}")
    endfunction()
endif ()

if (NOT COMMAND "ansi_escape_sequence")

    #! ansi_escape_sequence : Define an ANSI escape sequence
    #
    # @see https://en.wikipedia.org/wiki/ANSI_escape_code
    # @see RSP_DEFAULT_ESCAPE_CHARACTER
    #
    # @example
    #       ansi_escape_sequence(OUTPUT MY_STYLE CODE "[1;31m")
    #       ansi_escape_sequence(OUTPUT RESTORE CODE "[0m")
    #       message("${MY_STYLE}Foo${RESTORE} bar")
    #
    # @param OUTPUT <variable>      The output variable to assign escape sequence to.
    # @param CODE <string>          The code sequence.
    # @param [ESCAPE <string>]      Escape character to use. Defaults to RSP_DEFAULT_ESCAPE_CHARACTER,
    #                               when none given.
    #
    # @return
    #     [OUTPUT]                  The escape sequence
    #
    function(ansi_escape_sequence)
        set(oneValueArgs OUTPUT ESCAPE)
        set(multiValueArgs CODE)

        cmake_parse_arguments(INPUT "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
        requires_arguments("OUTPUT;CODE" INPUT)

        # ---------------------------------------------------------------------------------------------- #
        # Resolve optional arguments

        # Escape character
        if (NOT DEFINED INPUT_ESCAPE)
            set(INPUT_ESCAPE "${RSP_DEFAULT_ESCAPE_CHARACTER}")
        endif ()

        # ---------------------------------------------------------------------------------------------- #

        set("${INPUT_OUTPUT}" "${INPUT_ESCAPE}${INPUT_CODE}")

        return(PROPAGATE "${INPUT_OUTPUT}")
    endfunction()
endif ()

if (NOT COMMAND "output_ansi_demo")

    #! output_ansi_demo : Outputs a demo of the predefined ANSI variables
    #
    # NOTE: You must ensure that ANSI has been enabled, to see the effect
    # in your terminal.
    #
    # @see enable_ansi()
    #
    function(output_ansi_demo)
        set(txt "Mash up each side of the spinach with one cup of pickles.")
        
        message("\nANSI output demo:")

        message("Text:")
        message("bold: ${TEXT_BOLD}${txt}${RESTORE}")
        message("dim/faint: ${TEXT_DIM}${txt}${RESTORE}")
        message("italic: ${TEXT_ITALIC}${txt}${RESTORE}")
        message("underline: ${TEXT_UNDERLINE}${txt}${RESTORE}")
        message("blink: ${TEXT_BLINK}${txt}${RESTORE}")
        message("inverse/reverse: ${TEXT_INVERSE}${txt}${RESTORE}")
        message("hidden/invisible: ${TEXT_HIDDEN}${txt}${RESTORE}")
        message("Strikethrough: ${TEXT_STRIKETHROUGH}${txt}${RESTORE}")
        
        message("\nColors")
        message("black: ${COLOR_BLACK}${txt}${RESTORE}")
        message("black bg: ${COLOR_BG_BLACK}${txt}${RESTORE}")
        message("black (bright): ${COLOR_BRIGHT_BLACK}${txt}${RESTORE}")
        message("black (bright) bg: ${COLOR_BRIGHT_BG_BLACK}${txt}${RESTORE}")

        message("red: ${COLOR_RED}${txt}${RESTORE}")
        message("red bg: ${COLOR_BG_RED}${txt}${RESTORE}")
        message("red (bright): ${COLOR_BRIGHT_RED}${txt}${RESTORE}")
        message("red (bright) bg: ${COLOR_BRIGHT_BG_RED}${txt}${RESTORE}")

        message("green: ${COLOR_GREEN}${txt}${RESTORE}")
        message("green bg: ${COLOR_BG_GREEN}${txt}${RESTORE}")
        message("green (bright): ${COLOR_BRIGHT_GREEN}${txt}${RESTORE}")
        message("green (bright) bg: ${COLOR_BRIGHT_BG_GREEN}${txt}${RESTORE}")

        message("yellow: ${COLOR_YELLOW}${txt}${RESTORE}")
        message("yellow bg: ${COLOR_BG_YELLOW}${txt}${RESTORE}")
        message("yellow (bright): ${COLOR_BRIGHT_YELLOW}${txt}${RESTORE}")
        message("yellow (bright) bg: ${COLOR_BRIGHT_BG_YELLOW}${txt}${RESTORE}")

        message("blue: ${COLOR_BLUE}${txt}${RESTORE}")
        message("blue bg: ${COLOR_BG_BLUE}${txt}${RESTORE}")
        message("blue (bright): ${COLOR_BRIGHT_BLUE}${txt}${RESTORE}")
        message("blue (bright) bg: ${COLOR_BRIGHT_BG_BLUE}${txt}${RESTORE}")

        message("magenta: ${COLOR_MAGENTA}${txt}${RESTORE}")
        message("magenta bg: ${COLOR_BG_MAGENTA}${txt}${RESTORE}")
        message("magenta (bright): ${COLOR_BRIGHT_MAGENTA}${txt}${RESTORE}")
        message("magenta (bright) bg: ${COLOR_BRIGHT_BG_MAGENTA}${txt}${RESTORE}")

        message("cyan: ${COLOR_CYAN}${txt}${RESTORE}")
        message("cyan bg: ${COLOR_BG_CYAN}${txt}${RESTORE}")
        message("cyan (bright): ${COLOR_BRIGHT_CYAN}${txt}${RESTORE}")
        message("cyan (bright) bg: ${COLOR_BRIGHT_BG_CYAN}${txt}${RESTORE}")

        message("white: ${COLOR_WHITE}${txt}${RESTORE}")
        message("white bg: ${COLOR_BG_WHITE}${txt}${RESTORE}")
        message("white (bright): ${COLOR_BRIGHT_WHITE}${txt}${RESTORE}")
        message("white (bright) bg: ${COLOR_BRIGHT_BG_WHITE}${txt}${RESTORE}")

        message("default: ${COLOR_DEFAULT}${txt}${RESTORE}")
        message("default bg: ${COLOR_BG_DEFAULT}${txt}${RESTORE}")
    endfunction()
endif ()