setup() {
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    _common_setup
}

@test "testing: bats common setup test" {
    run bash -c "cd $( dirname ${BATS_TEST_FILENAME} ) >/dev/null 2>&1 && pwd"
    assert_equal "${output}" "${CTX}"
}

@test "testing: ensure image availability (build)" {
    _ensure_image
}