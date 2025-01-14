# -------------------------------------------------------------------------------------------------------------- #
# Responsible for downloading and configuring CPM package manager
# @see https://github.com/cpm-cmake/CPM.cmake
#
# This modules is inspired by Adobe's version of `CPM.cmake` (Copyright 2022 Adobe - Apache License 2.0).
# @see https://github.com/adobe/lagrange/blob/main/cmake/recipes/external/CPM.cmake
# -------------------------------------------------------------------------------------------------------------- #

# Prevent this setup from being included multiple times.
include_guard(GLOBAL)

# TODO: --------------------------------------------------------------------------

# TODO: Remove include again
include("rsp/helpers")

# The default version of CPM to download, unless a newer version available.
set(CPM_DOWNLOAD_VERSION 0.40.1)

# Version constraint used for when checking newer versions (git's "glob" matching patterns).
set(CPM_VERSION_CONSTRAINT "v0.40.*")
set(CPM_REPOSITORY "https://github.com/cpm-cmake/CPM.cmake.git")

# Ensure Git is available
find_package(Git REQUIRED)

# TODO: Avoid running this too often - CACHING !!!

# List available tags in the remote repository.
# @see https://git-scm.com/docs/git-ls-remote
execute_process(
        COMMAND ${GIT_EXECUTABLE} ls-remote --tags --refs --sort=-version:refname ${CPM_REPOSITORY} ${CPM_VERSION_CONSTRAINT}
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        RESULT_VARIABLE status
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
)

if (NOT status EQUAL 0)
    # In case of failure, continue by using the default version.
    message(AUTHOR_WARNING
            "Unable to list available CPM versions that match \"${CPM_VERSION_CONSTRAINT}\"\n"
            "Git exit code: ${status}\n"
            "Git error message: ${error}"
            " - called from ${CMAKE_CURRENT_LIST_FILE}\n"
    )
else ()
    # Replace newlines from result (convert to implicit list)
    string(REPLACE "\n" ";" result "${result}")
    list(POP_FRONT result first)

    # Find version tag
    string(REGEX MATCH "(v*)(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[\.0-9A-Za-z-]+)?([+][\.0-9A-Za-z-]+)?$" foundVersion "${first}")
    if (NOT foundVersion STREQUAL "")
        # Strip evt. "v" prefix
        string(REPLACE "v" "" foundVersion "${foundVersion}")

        # Use newer version, if applicable...
        if (foundVersion VERSION_GREATER CPM_DOWNLOAD_VERSION)
            message(STATUS "Newer version of CPM available: ${foundVersion}")
            set(CPM_DOWNLOAD_VERSION ${foundVersion})
        endif ()
    endif ()
endif ()

# TODO: --------------------------------------------------------------------------

## Set the desired CPM version
#set(CPM_DOWNLOAD_VERSION 0.40.1)

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
