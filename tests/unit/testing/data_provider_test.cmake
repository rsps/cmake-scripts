include("rsp/testing")

define_test_case(
    "Data Provider Test"
    LABELS "data-provider;callback;testing"
)

# -------------------------------------------------------------------------------------------------------------- #
# Data Providers
# -------------------------------------------------------------------------------------------------------------- #

#! provides_data_items : Returns data-set for tests
#
# @param <variable> output
#
# @return
#   output      List of items
#
function(provides_data_items output)
    set("${output}" "a;b;c;d")
    return (PROPAGATE "${output}")
endfunction()

# -------------------------------------------------------------------------------------------------------------- #
# Actual tests
# -------------------------------------------------------------------------------------------------------------- #

define_test(
    "can use items from data provider"
    "receives_data_from_data_provider"
    DATA_PROVIDER "provides_data_items"
)
function(receives_data_from_data_provider item)
    string(LENGTH "${item}" length)

    assert_greater_than(0 length MESSAGE "Invalid item provided: '${item}' (length: ${length})")

    # Ensure that given item exists in the data provider list.
    provides_data_items(control_list)
    assert_in_list("${item}" control_list MESSAGE "Item is not in data provider: '${item}'")
endfunction()