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

include(CMakePackageConfigHelpers)

# Introduce variables:
# * CMAKE_INSTALL_LIBDIR
# * CMAKE_INSTALL_BINDIR
# * CMAKE_INSTALL_INCLUDEDIR
include(GNUInstallDirs)

# Layout. This works for all platforms:
#   * <prefix>/lib*/cmake/<PROJECT-NAME>
#   * <prefix>/lib*/
#   * <prefix>/include/
set(config_install_dir "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")

set(generated_dir "${CMAKE_CURRENT_BINARY_DIR}")

# Configuration
# set(version_config "${generated_dir}/${PROJECT_NAME}-version.cmake")
set(project_config "${generated_dir}/${PROJECT_NAME}-config.cmake")

#configure_package_config_file(
#    "cmake/rsp-cmake-scripts-config.cmake.in"
#    "${CMAKE_CURRENT_BINARY_DIR}/cmake/rsp/rsp-cmake-scripts-config.cmake"
#
#    INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/rsp"
#    #PATH_VARS INCLUDE_INSTALL_DIR SYSCONFIG_INSTALL_DIR
#)

configure_package_config_file(
    "cmake/${PROJECT_NAME}-config.cmake.in"
    "${project_config}"
    INSTALL_DESTINATION "${config_install_dir}"
)

# TODO: CMake Version file

#install(
#    FILES
#        "${CMAKE_CURRENT_BINARY_DIR}/cmake/rsp/rsp-cmake-scripts-config.cmake"
#        # "${CMAKE_CURRENT_BINARY_DIR}/FooConfigVersion.cmake"
#    DESTINATION
#        "${CMAKE_INSTALL_LIBDIR}/cmake/rsp"
#)

# Config
#   * <prefix>/lib/cmake/Foo/FooConfig.cmake
#   * <prefix>/lib/cmake/Foo/FooConfigVersion.cmake
install(
    FILES
        "${project_config}"
        #"${version_config}"
    DESTINATION
        "${config_install_dir}"
)