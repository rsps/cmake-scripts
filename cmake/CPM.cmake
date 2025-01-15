# -------------------------------------------------------------------------------------------------------------- #
# Responsible for downloading and configuring CPM package manager
# @see https://github.com/cpm-cmake/CPM.cmake
#
# This modules is slightly inspired by Adobe's version of `CPM.cmake` (Copyright 2022 Adobe - Apache License 2.0).
# @see https://github.com/adobe/lagrange/blob/main/cmake/recipes/external/CPM.cmake
# -------------------------------------------------------------------------------------------------------------- #

# Prevent this setup from being included multiple times.
include_guard(GLOBAL)

# The default version of CPM to download (unless a newer version available).
set(CPM_DOWNLOAD_VERSION 0.40.1)

# Version constraint used for when checking newer versions (git's "glob" matching patterns).
set(CPM_VERSION_CONSTRAINT "v0.40.*")

# -------------------------------------------------------------------------------------------------------------- #
# Utility functions
# -------------------------------------------------------------------------------------------------------------- #

#! find_cpm_version : Finds the latest CPM version, acc. to given version constraint
#
# @param OUTPUT <variable>          The output variable to assign the found version tag
# @param CONSTRAINT <string>        Glob match pattern for tag (version constraint).
# @param [CACHE_TTL <number>]       Optional TTL (seconds) for cached version. Defaults to
#                                   600 seconds (10 minutes).
# @param [FORCE]                    OPTION, function is forced to check CPM repository for
#                                   newer version. If option not specified, then cached
#                                   version will be returned, if available.
#
# @return
#     [OUTPUT]                      Found version tag, e.g. "0.40.10" (without "v" prefix)
#
# @throws
#
function(find_cpm_version)
    set(options FORCE) # N/A
    set(oneValueArgs OUTPUT CONSTRAINT CACHE_TTL)
    set(multiValueArgs "") # N/A

    cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Ensure required arguments are defined
    set(requiredArgs "OUTPUT;CONSTRAINT")
    foreach (name ${requiredArgs})
        if (NOT DEFINED INPUT_${name})
            message(FATAL_ERROR "${name} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
        endif ()
    endforeach ()

    # Resolve optional arguments
    if (NOT DEFINED INPUT_CACHE_TTL)
        set(INPUT_CACHE_TTL 600) # 10 minutes
    endif ()

    # Used cached version, if not forced
    string(TIMESTAMP now "%s")
    if (NOT INPUT_FORCE
        AND DEFINED CPM_FOUND_VERSION
        AND DEFINED CPM_FOUND_VERSION_EXPIRES_AT
        AND now LESS CPM_FOUND_VERSION_EXPIRES_AT
    )
        message(VERBOSE "Using cached CPM version: ${CPM_FOUND_VERSION}")

        # Return the found version
        set("${INPUT_OUTPUT}" "${CPM_FOUND_VERSION}")
        return(
            PROPAGATE
            "${INPUT_OUTPUT}"
        )
    endif ()

    message(STATUS "Checking for newer CPM version...")

    # Ensure Git is available
    find_package(Git REQUIRED)

    # List available tags in the remote repository.
    # @see https://git-scm.com/docs/git-ls-remote
    # CPM git repository
    set(repository "https://github.com/cpm-cmake/CPM.cmake.git")
    execute_process(
            COMMAND ${GIT_EXECUTABLE} ls-remote --tags --refs --sort=-version:refname ${repository} ${INPUT_CONSTRAINT}
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
            RESULT_VARIABLE status
            OUTPUT_VARIABLE result
            ERROR_VARIABLE error
            OUTPUT_STRIP_TRAILING_WHITESPACE
            TIMEOUT 1
    )

    # Abort if git command failed
    if (NOT status EQUAL 0)
        # In case of failure, continue by using the default version.
        message(AUTHOR_WARNING
                "Unable to list available CPM versions that match \"${CPM_VERSION_CONSTRAINT}\"\n"
                "Git exit code: ${status}\n"
                "Git error message: ${error}"
                " - called from ${CMAKE_CURRENT_LIST_FILE}\n"
        )
        return()
    endif ()

    # Replace newlines from result (convert to implicit list)
    string(REPLACE "\n" ";" result "${result}")
    list(LENGTH result amount)

    # Abort if no version tags found
    if (amount EQUAL 0)
        message(WARNING "No version tags available in CPM repo: \"${INPUT_REPOSITORY}\"")
        return()
    endif ()

    # Extract the version tag from the first listed tag
    # @see https://git-scm.com/docs/git-ls-remote#_output
    list(POP_FRONT result first)
    string(REGEX MATCH "(v*)(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[\.0-9A-Za-z-]+)?([+][\.0-9A-Za-z-]+)?$" foundVersion "${first}")

    # Abort if no version tag could be extracted
    if (foundVersion STREQUAL "")
        message(WARNING "Version tag could not be extracted from \"${first}\"")
        return()
    endif ()

    # Strip evt. "v" prefix
    string(REPLACE "v" "" foundVersion "${foundVersion}")

    # Force cache the resulting found version, along with an expire timestamp
    set(CPM_FOUND_VERSION "${foundVersion}" CACHE STRING "Found CPM version" FORCE)
    string(TIMESTAMP now "%s")
    math(EXPR expires_at "${now} + ${INPUT_CACHE_TTL}")
    set(CPM_FOUND_VERSION_EXPIRES_AT "${expires_at}" CACHE STRING "Found CPM version (expire timestamp)" FORCE)

    # Return the found version
    # message(STATUS "    Found version ${foundVersion} (${repository})")
    set("${INPUT_OUTPUT}" "${foundVersion}")
    return(
        PROPAGATE
        "${INPUT_OUTPUT}"
    )
endfunction()

#! download_cpm : Downloads specified version of CPM
#
# @param version The target version to download
# @param download_location Location where the downloaded file must be placed
#
function(download_cpm version download_location)
    message(STATUS "Downloading CPM v${version} to ${download_location}")

    file(DOWNLOAD
            https://github.com/cpm-cmake/CPM.cmake/releases/download/v${version}/CPM.cmake
            ${download_location}
    )
endfunction()

# -------------------------------------------------------------------------------------------------------------- #
# Perform CPM download
# -------------------------------------------------------------------------------------------------------------- #

# Find latest CPM version
find_cpm_version(
    OUTPUT LATEST_CPM_VERSION
    CONSTRAINT ${CPM_VERSION_CONSTRAINT}
    # CACHE_TTL 15
    # FORCE
)

# Use found CPM version, if applicable...
if (NOT foundVersion STREQUAL "" AND LATEST_CPM_VERSION VERSION_GREATER CPM_DOWNLOAD_VERSION)
    message(VERBOSE "Setting target download CPM version from ${CPM_DOWNLOAD_VERSION} to ${LATEST_CPM_VERSION}")

    # Force overwrite evt. existing cached entry
    set(CPM_DOWNLOAD_VERSION ${LATEST_CPM_VERSION})
endif ()

# Skip download of CPM, if it is already initialised. This part will most likely only be true, when this project
# is consumed by a top-level project.
if (DEFINED CPM_INITIALIZED AND DEFINED CPM_VERSION)
    # Warn developer if an older version of CPM is running.
    if (CPM_VERSION VERSION_LESS CPM_DOWNLOAD_VERSION)
        message(
            AUTHOR_WARNING
                "You are running CPM v${CPM_VERSION} which appears to be outdated. Please upgrade CPM to \
                v${CPM_DOWNLOAD_VERSION} or higher. \
                See https://github.com/cpm-cmake/CPM.cmake for more information."
        )
    endif ()

    message(VERBOSE "Initialised CPM v${CPM_VERSION} detected, skipping download of CPM v${CPM_DOWNLOAD_VERSION}")
    return()
endif ()

# Set download location, in accordance to CPM's own preferred download location(s)
if(CPM_SOURCE_CACHE)
    set(CPM_DOWNLOAD_LOCATION "${CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
elseif(DEFINED ENV{CPM_SOURCE_CACHE})
    set(CPM_DOWNLOAD_LOCATION "$ENV{CPM_SOURCE_CACHE}/cpm/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
else()
    set(CPM_DOWNLOAD_LOCATION "${CMAKE_BINARY_DIR}/cmake/CPM_${CPM_DOWNLOAD_VERSION}.cmake")
endif()

# Expand relative path. This is important if the provided path contains a tilde (~)
get_filename_component(CPM_DOWNLOAD_LOCATION ${CPM_DOWNLOAD_LOCATION} ABSOLUTE)

# Start (or resume download)
if(NOT (EXISTS ${CPM_DOWNLOAD_LOCATION}))
    download_cpm(${CPM_DOWNLOAD_VERSION} ${CPM_DOWNLOAD_LOCATION})
else()
    # resume download if it previously failed
    file(READ ${CPM_DOWNLOAD_LOCATION} check)

    if("${check}" STREQUAL "")
        download_cpm(${CPM_DOWNLOAD_VERSION} ${CPM_DOWNLOAD_LOCATION})
    endif()

    unset(check)
endif()

# Finally, include the downloaded CPM package manager script
include(${CPM_DOWNLOAD_LOCATION})
