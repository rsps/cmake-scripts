# -------------------------------------------------------------------------------------------------------------- #
# Version utilities
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/version module included")

include("rsp/git")

if (NOT COMMAND "semver_parse")
    #! semver_parse : Parses a semantic version string
    #
    # @see https://semver.org/
    #
    # @example
    #       semver_parse(VERSION "v3.4.22-beta.3+AF1004" OUTPUT foo)
    #       message("${foo_VERSION}") # 3.4.22
    #
    # @param VERSION                    The version string to parse
    # @param OUTPUT                     The output variable to assign parsed results to
    #
    # @return
    #     [OUTPUT]                      The full version string as provided, e.g. "v3.4.22-beta.3+AF1004"
    #     [OUTPUT]_VERSION              CMake friendly version (major.minor.patch), e.g. "3.4.22"
    #     [OUTPUT]_SEMVER               Full version string (without eventual "v" prefix), e.g. "3.4.22-beta.3+AF1004"
    #     [OUTPUT]_MAJOR                Major version, e.g. "3"
    #     [OUTPUT]_MINOR                Minor version, e.g. "4"
    #     [OUTPUT]_PATCH                Patch version, e.g. "22"
    #     [OUTPUT]_PRE_RELEASE          Pre-release, e.g. "beta.3"
    #     [OUTPUT]_BUILD_METADATA       build-meta data, e.g. "AF1004"
    #
    # @throws If given VERSION is not a valid semantic version
    #
    function(semver_parse)
        set(options "") # N/A
        set(oneValueArgs VERSION OUTPUT)
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        foreach (name ${oneValueArgs})
            if (NOT DEFINED INPUT_${name})
                message(FATAL_ERROR "${name} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Remove eventual "v" prefix from given version string
        set(cleanVersion "${INPUT_VERSION}")
        string(REGEX REPLACE "^[v]" "" cleanVersion "${INPUT_VERSION}")

        # Parse given version string
        string(REGEX MATCH "^(0|[1-9][0-9]*)[.](0|[1-9][0-9]*)[.](0|[1-9][0-9]*)(-[.0-9A-Za-z-]+)?([+][.0-9A-Za-z-]+)?$" matches "${cleanVersion}")
        if (CMAKE_MATCH_COUNT LESS 3)
            message(FATAL_ERROR "${cleanVersion} is not a valid semantic version")
        endif ()

        # Extract parts
        set("${INPUT_OUTPUT}" "${INPUT_VERSION}") # Full version, as provided
        set("${INPUT_OUTPUT}_SEMVER" "${CMAKE_MATCH_0}") # Semantic version (without "v" prefix")
        set("${INPUT_OUTPUT}_MAJOR" "${CMAKE_MATCH_1}")
        set("${INPUT_OUTPUT}_MINOR" "${CMAKE_MATCH_2}")
        set("${INPUT_OUTPUT}_PATCH" "${CMAKE_MATCH_3}")
        set("${INPUT_OUTPUT}_PRE_RELEASE" "${CMAKE_MATCH_4}")
        set("${INPUT_OUTPUT}_BUILD_METADATA" "${CMAKE_MATCH_5}")
        set("${INPUT_OUTPUT}_VERSION" "${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}") # major.minor.patch

        # Remove eventual "-" or "+" prefixes from pre-release and build-metadata
        string(REGEX REPLACE "^[-]" "" ${INPUT_OUTPUT}_PRE_RELEASE "${${INPUT_OUTPUT}_PRE_RELEASE}")
        string(REGEX REPLACE "^[+]" "" ${INPUT_OUTPUT}_BUILD_METADATA "${${INPUT_OUTPUT}_BUILD_METADATA}")

        return(
            PROPAGATE
            "${INPUT_OUTPUT}"
            "${INPUT_OUTPUT}_VERSION"
            "${INPUT_OUTPUT}_SEMVER"
            "${INPUT_OUTPUT}_MAJOR"
            "${INPUT_OUTPUT}_MINOR"
            "${INPUT_OUTPUT}_PATCH"
            "${INPUT_OUTPUT}_PRE_RELEASE"
            "${INPUT_OUTPUT}_BUILD_METADATA"
        )
    endfunction()
endif ()