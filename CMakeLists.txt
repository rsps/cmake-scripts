# -------------------------------------------------------------------------------------------------------------- #
# RSP CMake Scripts
# -------------------------------------------------------------------------------------------------------------- #

cmake_minimum_required(VERSION 3.30)

# Append this package's cmake scripts in module path
list(FIND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" hasModulePath)
if(${hasModulePath} STREQUAL "-1")
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
endif()

# Abort if building in-source
include("rsp/helpers")
fail_when_build_in_source()

# Run only when this project is the root project
if (CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    # Setup package manager
    set(CPM_USE_NAMED_CACHE_DIRECTORIES ON)
endif()

include("CPM")

# -------------------------------------------------------------------------------------------------------------- #
# Project
# -------------------------------------------------------------------------------------------------------------- #

# Get project's version from file
include("rsp/version")
version_from_file(
    FILE "${CMAKE_CURRENT_SOURCE_DIR}/VERSION"
    OUTPUT version
    EXIT_ON_FAILURE
)

# Define this cmake project
project(rsp-cmake-scripts
    VERSION "${version_VERSION}"
    DESCRIPTION "A collection of CMake scripts for C++ projects"
    HOMEPAGE_URL "https://github.com/rsps/cmake-scripts"
    LANGUAGES NONE
)

# Ensure parent project has modules and other properties available.
if(NOT CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
    set("${PROJECT_NAME}_VERSION" "${PROJECT_VERSION}" PARENT_SCOPE)
    set("${PROJECT_NAME}_SEMVER" "${version_SEMVER}" PARENT_SCOPE)
endif()

# -------------------------------------------------------------------------------------------------------------- #
# Dependencies
# -------------------------------------------------------------------------------------------------------------- #

include("dependencies.cmake")

if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    include("dev-dependencies.cmake")
endif()

# -------------------------------------------------------------------------------------------------------------- #
# Misc.
# -------------------------------------------------------------------------------------------------------------- #

# include("rsp/helpers")

# dump(CMAKE_MODULE_PATH FOO BAR PROJECT_NAME)