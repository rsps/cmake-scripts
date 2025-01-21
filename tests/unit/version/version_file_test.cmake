include("rsp/testing")
include("rsp/version")

define_test_case(
    "Version File Utils Test"
    LABELS "semver;version;version-file"

    BEFORE "prepare_version_file_tests"
    AFTER "cleanup_dummy_repo"
)

macro(prepare_version_file_tests)
    # Make output dir, if one does not exist
    set(OUTPUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/output/version")
    if (NOT EXISTS "${OUTPUT_DIR}")
        file(MAKE_DIRECTORY "${OUTPUT_DIR}")
    endif ()
    set(OUTPUT_DIR "${OUTPUT_DIR}" PARENT_SCOPE)

endmacro()

macro(cleanup_dummy_repo)
    # Clear dummy repository
    file(REMOVE_RECURSE "${OUTPUT_DIR}")
endmacro()

# -------------------------------------------------------------------------------------------------------------- #
# Actual Tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("can write and read version file" "read_write_version_file")
function(read_write_version_file)
    set(target "${OUTPUT_DIR}/version.txt")
    set(version "v1.0.0-rc.3+AF558412---H58")

    write_version_file(
        FILE "${target}"
        VERSION "${version}"
    )

    version_from_file(
        FILE "${target}"
        OUTPUT result
    )

    assert_string_equals("${result}" "${version}" MESSAGE "Incorrect version read from file")
endfunction()

define_test("fails writing version file when invalid version" "fails_write_when_invalid_version" EXPECT_FAILURE)
function(fails_write_when_invalid_version)
    set(target "${OUTPUT_DIR}/version.txt")
    set(version "1.0")

    write_version_file(
        FILE "${target}"
        VERSION "${version}"
    )
endfunction()

define_test("fails reading version file when invalid version" "fails_read_when_invalid_version" EXPECT_FAILURE)
function(fails_read_when_invalid_version)
    set(target "${OUTPUT_DIR}/version.txt")
    set(version "0.5")

    file(WRITE "${target}" "${version}")

    version_from_file(
        FILE "${target}"
        OUTPUT result
    )
endfunction()

define_test("returns default version when file does not exist" "returns_default_version")
function(returns_default_version)
    set(target "${OUTPUT_DIR}/unknown-version-file")
    set(default_version "1.0.1")

    version_from_file(
        FILE "${target}"
        OUTPUT result_a
    )
    assert_string_equals("0.0.0" result_a MESSAGE "Incorrect default version")

    version_from_file(
        FILE "${target}"
        OUTPUT result_b
        DEFAULT "${default_version}"
    )
    assert_string_equals("${default_version}" result_b MESSAGE "Incorrect default custom version")
endfunction()

define_test("fails when file does not exist and specified" "fails_read_when_file_does_not_exist" EXPECT_FAILURE)
function(fails_read_when_file_does_not_exist)
    set(target "${OUTPUT_DIR}/unknown-version-file")

    version_from_file(
        FILE "${target}"
        OUTPUT result
        EXIT_ON_FAILURE
    )
endfunction()