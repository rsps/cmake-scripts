# -------------------------------------------------------------------------------------------------------------- #
# Development Dependencies
# -------------------------------------------------------------------------------------------------------------- #

include_guard()

# Include regular dependencies
include("dependencies.cmake")

function(install_dev_dependencies)
    message(VERBOSE "Installing Development Dependencies for ${PROJECT_NAME}")

    # Avoid building tests for dependencies...
    set(BUILD_TESTING off)

    # Add dev-dependencies here...
    message(VERBOSE "    N/A")

endfunction()
safeguard_properties(CALLBACK "install_dev_dependencies" PROPERTIES BUILD_TESTING)
