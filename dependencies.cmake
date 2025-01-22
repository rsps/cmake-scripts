# -------------------------------------------------------------------------------------------------------------- #
# Dependencies
# -------------------------------------------------------------------------------------------------------------- #

include_guard()

function(install_dependencies)
    message(STATUS "Installing Dependencies for ${PROJECT_NAME}")

    # Avoid building tests for dependencies...
    set(BUILD_TESTING off)

    # Add dependencies here...
    message(STATUS "    N/A")

endfunction()
safeguard_properties(CALLBACK "install_dependencies" PROPERTIES BUILD_TESTING)
