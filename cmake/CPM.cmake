# -------------------------------------------------------------------------------------------------------------- #
# Responsible for downloading and configuring CPM package manager
# @see https://github.com/cpm-cmake/CPM.cmake
#
# This modules is inspired by Adobe's version of `CPM.cmake` (Copyright 2022 Adobe - Apache License 2.0).
# @see https://github.com/adobe/lagrange/blob/main/cmake/recipes/external/CPM.cmake
# -------------------------------------------------------------------------------------------------------------- #

# Prevent this setup from being included multiple times.
include_guard(GLOBAL)

# Set the desired CPM version
set(CPM_DOWNLOAD_VERSION 0.40.1)

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
