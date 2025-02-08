# -------------------------------------------------------------------------------------------------------------- #
# Dependencies
# -------------------------------------------------------------------------------------------------------------- #

include_guard()

function(install_dependencies)
    message(VERBOSE "Installing Dependencies for ${PROJECT_NAME}")

    # Avoid building tests for dependencies...
    set(BUILD_TESTING off)

    # Add dependencies here...
    message(VERBOSE "    N/A")

endfunction()
safeguard_properties(CALLBACK "install_dependencies" PROPERTIES BUILD_TESTING)
