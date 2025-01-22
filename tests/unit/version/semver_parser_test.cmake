include("rsp/testing")
include("rsp/version")

define_test_case(
    "Semantic Version Parser Test"
    LABELS "semver;version"
)

# -------------------------------------------------------------------------------------------------------------- #
# Data Providers
# -------------------------------------------------------------------------------------------------------------- #

#! provides_versions : Returns versions data-set
#
# @param <variable> output
#
# @return
#   output      List of items
#
function(provides_versions output)
    set("${output}"
        "0.0.0"
        "1.0.0"
        "v1.0.0"
        "1.2.3"
        "999.999.999"
        "1.0.0-alpha"
        "1.0.0-alpha.2"
        "1.0.0-alpha.beta"
        "1.0.0-rc.1"
        "1.0.0-beta"
        "2.0.0-beta.3"
        "1.0.0+21AF26D3"
        "2.0.0+21AF26D3----117B344092BD"
        "4.0.0-alpha+001"
        "2.0.0-beta+exp.sha.5114f85"
    )
    return (PROPAGATE "${output}")
endfunction()

#! provides_invalid_versions : Returns invalid versions data-set
#
# @param <variable> output
#
# @return
#   output      List of items
#
function(provides_invalid_versions output)
    set("${output}"
        "0"
        "0.0"
        "1.0"
        "1.5"
        "x.0.0"
        "0.x.0"
        "0.0.x"
        "-1.0.0"
        "1.-1.0"
        "1.1.-1"
        "1.0.0alpha"
        "1.0.0-beta/117B344092BD"
        "1.0.0-rc%21AF26D3"
    )
    return (PROPAGATE "${output}")
endfunction()

# -------------------------------------------------------------------------------------------------------------- #
# Actual tests
# -------------------------------------------------------------------------------------------------------------- #

define_test(
    "can parse semantic version"
    "can_parse_semver"
    DATA_PROVIDER "provides_versions"
)
function(can_parse_semver version)
    #message("input: ${version}")

    semver_parse(
        VERSION "${version}"
        OUTPUT result
    )

    assert_string_not_empty("${result}" MESSAGE "Expected full version string (${version})")

    # -------------------------------------------------------------------------------------- #

    assert_defined(result_MAJOR MESSAGE "Expected xxx_MAJOR not defined")
    assert_string_not_empty("${result_MAJOR}" MESSAGE "Expected major version from ${version}")

    assert_defined(result_MINOR MESSAGE "Expected xxx_MINOR not defined")
    assert_string_not_empty("${result_MINOR}" MESSAGE "Expected minor version from ${version}")

    assert_defined(result_PATCH MESSAGE "Expected xxx_PATCH not defined")
    assert_string_not_empty("${result_PATCH}" MESSAGE "Expected patch version from ${version}")

    # -------------------------------------------------------------------------------------- #

    assert_defined(result_PRE_RELEASE MESSAGE "Expected xxx_PRE_RELEASE not defined")

    # NOTE: pre-release can be empty. Store for later use...
    set(pre_release "${result_PRE_RELEASE}")

    # -------------------------------------------------------------------------------------- #

    assert_defined(result_BUILD_METADATA MESSAGE "Expected xxx_BUILD_METADATA not defined")

    # NOTE: build metadata can be empty. Store for later use...
    set(build_metadata "${result_BUILD_METADATA}")

    # -------------------------------------------------------------------------------------- #

    assert_defined(result_VERSION MESSAGE "Expected xxx_VERSION not defined")
    assert_string_not_empty("${result_VERSION}" MESSAGE "Expected major.minor.patch versions from ${version}")
    assert_string_equals("${result_MAJOR}.${result_MINOR}.${result_PATCH}" result_VERSION MESSAGE "Incorrect major.minor.patch in xxx_VERSION (${version})")

    # -------------------------------------------------------------------------------------- #

    assert_defined(result_SEMVER MESSAGE "Expected xxx_SEMVER not defined")
    assert_string_not_empty("${result_SEMVER}" MESSAGE "Expected major.minor.patch versions from ${version}")

    # Define "expected" SEMVER string
    set(expected "${result_VERSION}")

    # Append pre-release, if available
    if (NOT pre_release STREQUAL "")
        set(expected "${expected}-${pre_release}")
    endif ()

    # Append build metadata, if available
    if (NOT build_metadata STREQUAL "")
        set(expected "${expected}+${build_metadata}")
    endif ()

    if(NOT ("${result_SEMVER}" STREQUAL "${expected}"))
        assert_truthy(false MESSAGE "xxx_SEMVER (${result_SEMVER}) is invalid, from ${version}")
    endif ()
endfunction()

define_test(
    "fails if not valid semantic version"
    "fails_when_invalid_semver"
    DATA_PROVIDER "provides_invalid_versions"
    EXPECT_FAILURE
)
function(fails_when_invalid_semver version)
    semver_parse(
        VERSION "${version}"
        OUTPUT result
    )
endfunction()