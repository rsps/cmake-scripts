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
    # @param VERSION <string>           The version string to parse
    # @param OUTPUT <variable>          The output variable to assign parsed results to
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

if (NOT COMMAND "write_version_file")

    #! write_version_file : Writes a version string to given file
    #
    # @see rsp/git::git_find_version_tag()
    #
    # @example
    #       # Defaults to version obtained via git
    #       write_version_file(FILE "version.txt")
    #       # Or, use custom version
    #       write_version_file(FILE "version.txt" VERSION "v1.4.3")
    #
    #       file(READ "version.txt" version)
    #       message("Version: ${version}") # E.g. "v1.4.3"
    #
    # Note: The specified version file will automatically be created, if it does not exist.
    # Existing version file is NOT overwritten, if its content matches specified or found
    # found version string.
    #
    # @param FILE <path>            Path to the target file
    # @param [VERSION <string>]     The version string to write in file.
    #                               Defaults to version obtain via `git_find_version_tag()`,
    #                               when no version specified.
    #
    function(write_version_file)
        set(options "") # N/A
        set(oneValueArgs FILE VERSION)
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "FILE")
        foreach (name ${requiredArgs})
            if (NOT DEFINED INPUT_${name})
                message(FATAL_ERROR "${name} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Resolve version, if none specified
        if (NOT DEFINED INPUT_VERSION)
            message(VERBOSE "No version specified, using git version tag")

            # Presume that working dir is the same as where the version file
            # must be written.
            get_filename_component(workingDir ${INPUT_FILE} DIRECTORY)

            # Find version tag
            git_find_version_tag(
                OUTPUT INPUT_VERSION
                WORKING_DIRECTORY ${workingDir}
            )
        endif ()

        # Prevent re-writing file, if the content is the same as the version.
        if (EXISTS ${INPUT_FILE})
            message(VERBOSE "${INPUT_FILE} file already exists")

            # Obtain existing version and compare it against the one provided or found.
            # Limit the maximum amount of bytes to 255, to prevent processing too large
            # version strings ("[..] A 255 character version string is probably overkill [...]").
            # @see https://semver.org/#does-semver-have-a-size-limit-on-the-version-string
            file(READ ${INPUT_FILE} existing LENGTH_MAXIMUM 255)

            # Avoid changing the version file's modification datetime, if versions match.
            if (existing STREQUAL INPUT_VERSION)
                message(VERBOSE "${INPUT_FILE} file already contains version string: ${INPUT_VERSION}")
                return()
            endif ()
        endif ()

        # Finally, write the version in specified file
        file(WRITE ${INPUT_FILE} ${INPUT_VERSION})
    endfunction()
endif ()