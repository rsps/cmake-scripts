include("rsp/testing")
include("rsp/git")

define_test_case(
    "Git Find Version Tag Test"
    LABELS "git;version;testing"

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

    # Commit a few empty commits...
    file(TOUCH "${OUTPUT_DIR}/README.md")
    execute_process(
        COMMAND ${GIT_EXECUTABLE} add .
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_b
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )
    execute_process(
        COMMAND ${GIT_EXECUTABLE} commit -m "testing..."
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_c
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )
    execute_process(
        COMMAND ${GIT_EXECUTABLE} tag "v1.0.0-alpha"
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_d
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )

    # Update content, commit and tag...
    file(WRITE "${OUTPUT_DIR}/README.md" "Lorum lipsum")
    execute_process(
        COMMAND ${GIT_EXECUTABLE} add .
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_e
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )
    execute_process(
        COMMAND ${GIT_EXECUTABLE} commit -m "another test"
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_f
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )
    execute_process(
        COMMAND ${GIT_EXECUTABLE} tag "v1.0.0-beta"
        WORKING_DIRECTORY "${OUTPUT_DIR}"
        RESULT_VARIABLE status_g
        OUTPUT_VARIABLE result
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        TIMEOUT 1
    )

    # Debug
#    dump(
#        status_a
#
#        status_b
#        status_c
#        status_d
#
#        status_e
#        status_f
#        status_g
#    )

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