# -------------------------------------------------------------------------------------------------------------- #
# Cache utilities
# -------------------------------------------------------------------------------------------------------------- #

include_guard(GLOBAL)

# Debug
message(VERBOSE "rsp/cache module included")

if (NOT DEFINED RSP_CACHE_EXPIRES_AT_KEY_AFFIX)
    set(RSP_CACHE_EXPIRES_AT_KEY_AFFIX "[rsp@expires_at]")
endif ()

if (NOT COMMAND "cache_set")

    #! cache_set : Cache given entry
    #
    # CAUTION: If key has already been cached, then it's value will be overwritten.
    # This is the equivalent of invoking cmake's `set()` with CACHE FORCE arguments.
    #
    # @see https://cmake.org/cmake/help/latest/command/set.html#set-cache-entry
    #
    # @param KEY <variable>         The variable to assign and cache
    # @param VALUE <mixed>          Value to assign and cache
    # @param [TYPE <type>]          Optional, Cmake cache entry type, BOOL, STRING,...etc
    #                               Defaults to STRING.
    # @param [TTL <number>]         Time-To-Live of cache entry in seconds.
    #                               If not specified, then entry is cached forever.
    # @param [DESCRIPTION <string>] Optional description of cache entry
    #
    # @return
    #     [KEY]                     The cached variable
    #
    function(cache_set)
        set(options "") # N/A
        set(oneValueArgs KEY VALUE TYPE TTL DESCRIPTION)
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "KEY;VALUE")
        foreach (name ${requiredArgs})
            if (NOT DEFINED INPUT_${name})
                message(FATAL_ERROR "${name} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Resolve optional arguments
        if (NOT DEFINED INPUT_TYPE)
            # @see https://cmake.org/cmake/help/latest/command/set.html#set-cache-entry
            set(INPUT_TYPE "STRING")
        endif ()
        if (NOT DEFINED INPUT_DESCRIPTION)
            set(INPUT_DESCRIPTION "Cached property")
        endif ()

        # Force cache given entry
        set("${INPUT_KEY}" "${INPUT_VALUE}" CACHE ${INPUT_TYPE} " ${INPUT_DESCRIPTION} (via rsp/cache module)" FORCE)

        # Make expires at key for cache entry
        cache_make_expires_at_key(EXPIRES_AT_KEY INPUT_KEY)

        # Store the expires at timestamp of cache entry
        if (DEFINED INPUT_TTL)
            string(TIMESTAMP now "%s")
            math(EXPR expires_at "${now} + ${INPUT_TTL}")

            set("${EXPIRES_AT_KEY}" "${expires_at}" CACHE STRING " Expiration timestamp for \"${INPUT_KEY}\" (via rsp/cache module)" FORCE)
        else ()
            # When no TTL has been specified, remove eventual previous stored TTl,
            # from the cache.
            unset("${EXPIRES_AT_KEY}" CACHE)
        endif ()

        # Finally, propagate cache entry
        return(
            PROPAGATE
            "${INPUT_KEY}"
        )
    endfunction()
endif ()

if (NOT COMMAND "cache_get")

    #! cache_get : Retrieve cache entry, if it exists
    #
    # @see https://cmake.org/cmake/help/latest/command/set.html#set-cache-entry
    # @see https://cmake.org/cmake/help/latest/command/if.html#defined
    #
    # @param KEY <variable>         The variable to assign result to
    # @param [DEFAULT <mixed>]      Default value to assign, if no cache entry found
    #
    # @return
    #     [KEY]                     The cached variable, or default value if
    #                               no cache entry was found
    #
    function(cache_get)
        set(options "") # N/A
        set(oneValueArgs KEY DEFAULT)
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "KEY")
        foreach (name ${requiredArgs})
            if (NOT DEFINED INPUT_${name})
                message(FATAL_ERROR "${name} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Resolve optional arguments
        if (NOT DEFINED INPUT_DEFAULT)
            set(INPUT_DEFAULT "")
        endif ()

        # Returns cached entry if it still exists
        # NB: the `cache_has()` function will automatically remove the entry,
        # if it has expired.
        cache_has(KEY ${INPUT_KEY} OUTPUT entry_exists)
        if (entry_exists EQUAL 1)
            message(VERBOSE "Found cache entry for ${INPUT_KEY}")
            set("${INPUT_KEY}" "${${INPUT_KEY}}")
            return(
                PROPAGATE
                "${INPUT_KEY}"
            )
        endif ()

        # Return default value
        message(VERBOSE "No cache entry found for ${INPUT_KEY}, returning default value \"${INPUT_DEFAULT}\"")
        set("${INPUT_KEY}" "${INPUT_DEFAULT}")
        return(
            PROPAGATE
            "${INPUT_KEY}"
        )
    endfunction()
endif ()

if (NOT COMMAND "cache_has")

    #! cache_has : Determine if a cached entry exists
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#defined
    #
    # @param KEY <variable>         The variable to check
    # @param OUTPUT <variable>      Default value to assign, if no cache entry found
    #
    # @return
    #     [OUTPUT]                  Exists status: 1 if entry exists,
    #                               0 otherwise.
    #
    function(cache_has)
        set(options "") # N/A
        set(oneValueArgs KEY OUTPUT)
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "KEY;OUTPUT")
        foreach (name ${requiredArgs})
            if (NOT DEFINED INPUT_${name})
                message(FATAL_ERROR "${name} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Determine if entry exists in cache
        if (DEFINED CACHE{${INPUT_KEY}})

            # If the entry exists and has an expiration timestamp, then we must ensure
            # that the entry is still valid (not yet expired)
            cache_has_expired(KEY ${INPUT_KEY} OUTPUT has_expired)

            if (has_expired EQUAL 1)
                message(VERBOSE "    ${INPUT_KEY} has expired")

                # Remove entry...
                cache_forget(KEY ${INPUT_KEY})

                set("${INPUT_OUTPUT}" 0)
                return(
                    PROPAGATE
                    "${INPUT_OUTPUT}"
                )
            endif ()

            # This means that an entry still exists...
            message(VERBOSE "    ${INPUT_KEY} exists")
            set("${INPUT_OUTPUT}" 1)
            return(
                PROPAGATE
                "${INPUT_OUTPUT}"
            )
        endif ()

        # No entry found...
        message(VERBOSE "No cache entry found for \"${INPUT_KEY}\"")
        set("${INPUT_OUTPUT}" 0)
        return(
            PROPAGATE
            "${INPUT_OUTPUT}"
        )
    endfunction()
endif ()

if (NOT COMMAND "cache_forget")

    #! cache_forget : Deletes cache entry, if it exists
    #
    # @see https://cmake.org/cmake/help/latest/command/if.html#defined
    #
    # @param KEY <variable>         Cached variable
    # @param [OUTPUT <variable>]    Optional, the variable to assign delete status
    #
    # @return
    #     [OUTPUT]                  Delete status: 1 if entry was and deleted,
    #                               0 otherwise.
    #
    function(cache_forget)
        set(options "") # N/A
        set(oneValueArgs KEY OUTPUT)
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "KEY")
        foreach (name ${requiredArgs})
            if (NOT DEFINED INPUT_${name})
                message(FATAL_ERROR "${name} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Remove entry if it exists
        if (DEFINED CACHE{${INPUT_KEY}})
            # Remove entry
            unset("${INPUT_KEY}" CACHE)

            # Remove entry's eventual expiration timestamp
            cache_make_expires_at_key(EXPIRES_AT_KEY INPUT_KEY)
            unset("${EXPIRES_AT_KEY}" CACHE)

            # Return success
            message(VERBOSE "Deleted cached \"${INPUT_KEY}\" entry")
            if (DEFINED INPUT_OUTPUT)
                set("${INPUT_OUTPUT}" 1)
                return(
                    PROPAGATE
                    "${INPUT_OUTPUT}"
                )
            endif ()
        endif ()

        # Return failure - no cached entry found
        message(VERBOSE "No cache entry found for \"${INPUT_KEY}\"")
        if (DEFINED INPUT_OUTPUT)
            set("${INPUT_OUTPUT}" 0)
            return(
                PROPAGATE
                "${INPUT_OUTPUT}"
            )
        endif ()
    endfunction()
endif ()

if (NOT COMMAND "cache_remember")

    #! cache_remember : Retrieve cached entry, or invoke callback and store resulting value
    #
    # @example
    #       # Function that generates complex value...
    #       function(makeValue output)
    #           set("${output}" "Bar")
    #           return (PROPAGATE "${output}")
    #       endfunction()
    #
    #       # Retrieve cache entry for foo, if it exists.
    #       # Otherwise, invoke the callback
    #       cache_remember(
    #           KEY foo
    #           CALLBACK makeValue
    #           TTL 300
    #       )
    #
    # NOTE: If no TTL is specified, then value is cached forever.
    #
    # @param KEY <variable>         The variable to assign and cache
    # @param CALLBACK <command>     Function that returns value to be cached
    # @param [TYPE <type>]          Optional, Cmake cache entry type, BOOL, STRING,...etc
    #                               Defaults to STRING.
    # @param [TTL <number>]         Time-To-Live of cache entry in seconds.
    #                               If not specified, then entry is cached forever.
    # @param [DESCRIPTION <string>] Optional description of cache entry
    #
    # @return
    #     [KEY]                     The cached variable
    function(cache_remember)
        set(options "") # N/A
        set(oneValueArgs KEY CALLBACK TYPE TTL DESCRIPTION)
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "KEY;CALLBACK")
        foreach (name ${requiredArgs})
            if (NOT DEFINED INPUT_${name})
                message(FATAL_ERROR "${name} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Ensure that callback exists
        if (NOT COMMAND ${INPUT_CALLBACK})
            message(FATAL_ERROR "Unable to cache ${INPUT_KEY}, callback ${INPUT_CALLBACK}() does not exist")
        endif ()

        # If cache entry exists, return found entry
        cache_has(KEY ${INPUT_KEY} OUTPUT exists)
        if (exists EQUAL 1)
            message(VERBOSE "Cache entry found for ${INPUT_KEY}")
            cache_get(KEY ${INPUT_KEY})
        else ()
            # Otherwise, resolve the cache entry's value via given callback
            message(VERBOSE "No cache entry found for ${INPUT_KEY}, invoking ${INPUT_CALLBACK}()")

            cmake_language(CALL ${INPUT_CALLBACK} value)
            cache_set(
                KEY ${INPUT_KEY}
                VALUE ${value}
                TTL ${INPUT_TTL}
                TYPE ${INPUT_TYPE}
                DESCRIPTION ${INPUT_DESCRIPTION}
            )
        endif ()

        # Finally, return the cached entry
        return (
            PROPAGATE
            "${INPUT_KEY}"
        )
    endfunction()
endif ()

# -------------------------------------------------------------------------------------------------------------- #
# Internals
# -------------------------------------------------------------------------------------------------------------- #

if (NOT COMMAND "cache_make_expires_at_key")

    #! cache_make_expires_at_key : Returns a key name for an "expires at" property
    #
    # @internal
    #
    # @param output     The variable to assign result to
    # @param key        Cache entry variable
    #
    # @return
    #     [output]      The resulting key name
    #
    function(cache_make_expires_at_key output key)
        set("${output}" "${${key}}${RSP_CACHE_EXPIRES_AT_KEY_AFFIX}")
        return(PROPAGATE "${output}")
    endfunction()
endif ()

if (NOT COMMAND "cache_has_expired")

    #! cache_has_expired : Determine if cache entry has expired
    #
    # NOTE: Method will return 0, if cache entry does not have
    # an expiration timestamp set.
    #
    # @internal
    #
    # @param KEY <variable>     Cached variable
    # @param OUTPUT <variable>  Optional, the variable to check expiration of
    #
    # @return
    #     [OUTPUT]              Expiration status: 1 if entry has expired, 0 otherwise.
    #
    function(cache_has_expired)
        set(options "") # N/A
        set(oneValueArgs KEY OUTPUT)
        set(multiValueArgs "") # N/A

        cmake_parse_arguments(INPUT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

        # Ensure required arguments are defined
        set(requiredArgs "KEY;OUTPUT")
        foreach (name ${requiredArgs})
            if (NOT DEFINED INPUT_${name})
                message(FATAL_ERROR "${name} argument is missing, for ${CMAKE_CURRENT_FUNCTION}()")
            endif ()
        endforeach ()

        # Make expires at key...
        cache_make_expires_at_key(EXPIRES_AT_KEY INPUT_KEY)

        # Abort if expiration timestamp key does not exist
        if (NOT DEFINED ${EXPIRES_AT_KEY})
            message(VERBOSE "No expiration timestamp found for ${INPUT_KEY}")
            set("${INPUT_OUTPUT}" 0)
            return(
                PROPAGATE
                "${INPUT_OUTPUT}"
            )
        endif ()

        message(VERBOSE "Expiration timestamp exists for ${INPUT_KEY}")

        # Determine if expired
        string(TIMESTAMP now "%s")
        if (now GREATER ${EXPIRES_AT_KEY})
            message(VERBOSE "    ${key} has expired")

            # Return the found version
            set("${INPUT_OUTPUT}" 1)
            return(
                PROPAGATE
                "${INPUT_OUTPUT}"
            )
        endif ()

        # Cache entry has not yet expired
        message(VERBOSE "    ${INPUT_KEY} has not yet expired")
        set("${INPUT_OUTPUT}" 0)
        return(
            PROPAGATE
            "${INPUT_OUTPUT}"
        )
    endfunction()
endif ()