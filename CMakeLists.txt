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
    LANGUAGES "CXX"
)

# Ensure parent project has modules and other properties available.
if(NOT PROJECT_IS_TOP_LEVEL)
    # TODO: PROBLEM - works only if FetchContent is done from the top-level
    # TODO: CMakeLists.txt file - or this is pure luck, if it works!!!
    # When FetchContent_MakeAvailable() is used, in a top-level project,
    # this will work fine, for adding this project's module path(s).
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)

    # TODO: But, if CPM is used for obtaining project, then this will sadly
    # TODO: not work.

    # TODO: Possible Solution: We need to create pacakge config and version files:
    # TODO: @see https://cmake.org/cmake/help/latest/manual/cmake-packages.7.html#package-configuration-file
    # TODO: @see https://cmake.org/cmake/help/latest/module/CMakePackageConfigHelpers.html#command:configure_package_config_file

    set("${PROJECT_NAME}_VERSION" "${PROJECT_VERSION}" PARENT_SCOPE)
    set("${PROJECT_NAME}_SEMVER" "${version_SEMVER}" PARENT_SCOPE)
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

# -------------------------------------------------------------------------------------------------------------- #
# TODO: Package Configuration
# -------------------------------------------------------------------------------------------------------------- #

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

#install(
#    TARGETS "${PROJECT_NAME}"
#    EXPORT "${PROJECT_NAME}-export"
##    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/${PROJECT_NAME}
##    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
##    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
##    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
#)
#
## Export cmake targets
#install(
#    EXPORT "${PROJECT_NAME}-export"
#    FILE "${PROJECT_NAME}-targets.cmake"
#    NAMESPACE "${PROJECT_NAME}::"
#    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}"
#)

# Write config-version
write_basic_package_version_file(
    ${PROJECT_NAME}-config-version.cmake
    VERSION "${PROJECT_VERSION}"
    COMPATIBILITY SameMinorVersion
)

# Configure installable cmake config
configure_package_config_file(
    "${PROJECT_SOURCE_DIR}/cmake/${PROJECT_NAME}-config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config.cmake"
    INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/rsp/${PROJECT_NAME}"
    NO_SET_AND_CHECK_MACRO
)

# Install config-version and config
install(
    FILES
        "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake"
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/rsp/${PROJECT_NAME}"
)