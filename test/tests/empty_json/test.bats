setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "config/fission.json: empty config object ({}) is valid config" {
    # empty json object is valid config
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -e FISSION_VERBOSE=true ${IMAGE} true
    assert_success

    assert_equal "${stderr}" ""
}
