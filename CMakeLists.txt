# -------------------------------------------------------------------------------------------------------------- #
# RSP CMake Scripts
# -------------------------------------------------------------------------------------------------------------- #

cmake_minimum_required(VERSION 3.30)

option(RSP_CMAKE_SCRIPTS_BUILD_TESTS "Build tests for the RSP CMake Scripts project" off)
option(RSP_ENABLE_ANSI "Enable ANSI output" false)

# -------------------------------------------------------------------------------------------------------------- #
# Setup
# -------------------------------------------------------------------------------------------------------------- #

# Append this package's cmake scripts in module path
list(FIND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" has_cmake_scripts_module_path)
if(has_cmake_scripts_module_path EQUAL -1)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" CACHE STRING " RSP CMake Scripts CMAKE_MODULE_PATH" FORCE)

    message(WARNING "Caching CMAKE_MODULE_PATH. Please rebuild your project, if a failure occur.")
endif()

# Abort if building in-source
include("rsp/helpers")
fail_in_source_build()

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
set("${PROJECT_NAME}_VERSION" "${PROJECT_VERSION}")
set("${PROJECT_NAME}_SEMVER" "${version_SEMVER}")

# Ensure parent project has modules and other properties available.
if(NOT PROJECT_IS_TOP_LEVEL)
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
    set("${PROJECT_NAME}_VERSION" "${${PROJECT_NAME}_VERSION}" PARENT_SCOPE)
    set("${PROJECT_NAME}_SEMVER" "${${PROJECT_NAME}_SEMVER}" PARENT_SCOPE)
endif()

# -------------------------------------------------------------------------------------------------------------- #
# Dependencies
# -------------------------------------------------------------------------------------------------------------- #

include("dependencies.cmake")

if(PROJECT_IS_TOP_LEVEL)
    include("dev-dependencies.cmake")
endif()

# -------------------------------------------------------------------------------------------------------------- #
# Toggle ANSI output
# -------------------------------------------------------------------------------------------------------------- #

include("rsp/output")

if (RSP_ENABLE_ANSI)
    enable_ansi()
else ()
    disable_ansi()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Post-dependencies project setup
# -------------------------------------------------------------------------------------------------------------- #

if(PROJECT_IS_TOP_LEVEL)
    include("rsp/debug")
    include("rsp/logging")
endif()

# -------------------------------------------------------------------------------------------------------------- #
# Tests
# -------------------------------------------------------------------------------------------------------------- #

if (RSP_CMAKE_SCRIPTS_BUILD_TESTS)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
    add_subdirectory("tests")
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Misc.
# -------------------------------------------------------------------------------------------------------------- #

# output_ansi_demo()
# dump(CMAKE_MODULE_PATH FOO BAR PROJECT_NAME)
