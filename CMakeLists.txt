# -------------------------------------------------------------------------------------------------------------- #
# RSP CMake Scripts
# -------------------------------------------------------------------------------------------------------------- #

cmake_minimum_required(VERSION 3.30)

# Append this package's cmake scripts in module path
list(FIND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" hasModule)
if(${hasModule} STREQUAL "-1")
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
endif()

# Setup package manager
if (NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    set(CPM_USE_NAMED_CACHE_DIRECTORIES ON)
endif()

include("CPM")

# -------------------------------------------------------------------------------------------------------------- #
# Project
# -------------------------------------------------------------------------------------------------------------- #

# TODO: Dynamically determine this package's version from git
project(rsp-cmake-scripts
    VERSION 0.1.0
    DESCRIPTION "A collection of CMake scripts for C++ projects"
    HOMEPAGE_URL "https://github.com/rsps/cmake-scripts"
    LANGUAGES NONE
)

# Ensure cmake scripts are available for parent projects.
if(NOT CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
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

# include("dump")
# include("dd")

# dump(CMAKE_MODULE_PATH FOO BAR)