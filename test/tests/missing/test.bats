setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "config/fission.json: fail on missing file" {
    run -- docker run --rm ${IMAGE} true
    assert_failure
}
