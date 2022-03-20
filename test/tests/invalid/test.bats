setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "config/fission.json: fail on malformated/invalid JSON" {
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -e FISSION_VERBOSE=true ${INIT} ${IMAGE} true
    assert_failure
}
