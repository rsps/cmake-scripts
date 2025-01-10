# -------------------------------------------------------------------------------------------------------------- #
# Git utilities
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/git module included")

# TODO: incomplete...

# TODO: To obtain local git tags, sorted acc. to their version:
# TODO:     git tag --sort=-version:refname
# TODO:     git tag --list --sort=-version:refname
# TODO: @see https://blog.boot.dev/open-source/view-git-tags-with-semver-ordering/

# TODO: Inspiration for setting in a file, via cmake...
# TODO: @see https://www.marcusfolkesson.se/blog/git-version-in-cmake/
# TODO: @see https://gitlab.orfeo-toolbox.org/bradh/otb/-/blob/develop/CMake/GetVersionFromGitTag.cmake
# TODO: @see https://github.com/nocnokneo/cmake-git-versioning-example/blob/master/GenerateVersionHeader.cmake