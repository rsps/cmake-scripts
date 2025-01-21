include("rsp/testing")
include("rsp/git")

define_test_case(
    "Git Find Version Tag Test"
    LABELS "git;version"

    BEFORE "prepare_dummy_repo"
    AFTER "cleanup_dummy_repo"
)

macro(prepare_dummy_repo)
    # Make output dir, if one does not exist
    set(OUTPUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/output/git")
    if (NOT EXISTS "${OUTPUT_DIR}")
        file(MAKE_DIRECTORY "${OUTPUT_DIR}")
    endif ()
    set(OUTPUT_DIR "${OUTPUT_DIR}" PARENT_SCOPE)

    # Clear dummy repository (from evt. previous run)
    set(target_file "${OUTPUT_DIR}/README.md")
    file(REMOVE "${target_file}")
    file(REMOVE_RECURSE "${OUTPUT_DIR}/.git")

    # Create a local repo
    execute_process(
        COMMAND ${GIT_EXECUTABLE} init
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_a
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )
    assert_equals(0 status_a MESSAGE "Unable to init local repo: ${error}")

    # Commit a few empty commits...
    file(TOUCH "${target_file}")
    execute_process(
        COMMAND ${GIT_EXECUTABLE} add .
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_b
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )
    assert_equals(0 status_b MESSAGE "Unable to stage file: ${error}")

    execute_process(
        COMMAND ${GIT_EXECUTABLE} commit -m "testing..."
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_c
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )
    assert_equals(0 status_c MESSAGE "Unable to create first commit: ${error}")

    execute_process(
        COMMAND ${GIT_EXECUTABLE} tag "v1.0.0-alpha"
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_d
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )
    assert_equals(0 status_d MESSAGE "Unable to create first tag: ${error}")

    # Update content, commit and tag...
    file(WRITE "${target_file}" "Lorum lipsum")
    execute_process(
        COMMAND ${GIT_EXECUTABLE} add .
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_e
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )
    assert_equals(0 status_e MESSAGE "Unable to stage file: ${error}")

    execute_process(
        COMMAND ${GIT_EXECUTABLE} commit -m "another test"
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_f
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )
    assert_equals(0 status_f MESSAGE "Unable to create second commit: ${error}")

    execute_process(
        COMMAND ${GIT_EXECUTABLE} tag "v1.0.0-beta"
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_g
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )
    assert_equals(0 status_g MESSAGE "Unable to create second tag: ${error}")

endmacro()

macro(cleanup_dummy_repo)
    # Clear dummy repository
    file(REMOVE_RECURSE "${OUTPUT_DIR}")
endmacro()

# -------------------------------------------------------------------------------------------------------------- #
# Actual tests
# -------------------------------------------------------------------------------------------------------------- #

define_test("can find nearest version tag" "can_find_version_tag")
function(can_find_version_tag)
    git_find_version_tag(
        OUTPUT version
        WORKING_DIRECTORY "${OUTPUT_DIR}"
    )

    assert_string_equals("v1.0.0-beta" version MESSAGE "Incorrect version obtained from local repo")
endfunction()

define_test("returns default version" "returns_default_version")
function(returns_default_version)
    git_find_version_tag(
        OUTPUT version_a
        WORKING_DIRECTORY "${OUTPUT_DIR}/unknown"
    )

    set(custom_default "v12.5.0")
    git_find_version_tag(
        OUTPUT version_b
        DEFAULT "${custom_default}"
        WORKING_DIRECTORY "${OUTPUT_DIR}/unknown"
    )

    assert_string_equals("0.0.0" version_a MESSAGE "Expected 0.0.0 as default version returned")
    assert_string_equals(custom_default version_b MESSAGE "Expected custom default version (${custom_default}) to be returned")
endfunction()

define_test("fails when requested and unable to find version" "fails_when_unable_to_find_version" EXPECT_FAILURE)
function(fails_when_unable_to_find_version)
    git_find_version_tag(
        OUTPUT version
        WORKING_DIRECTORY "${OUTPUT_DIR}/unknown"
        EXIT_ON_FAILURE
    )
endfunction()