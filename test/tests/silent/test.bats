setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "fission config: silence info logging" {
    run -- docker run --rm -v ${CTX}/on.json:/etc/fission/fission.json ${INIT} ${ARCH} ${IMAGE} true
    assert_success
    
    refute_output
}

@test "fission config: info logging with prefix" {
    run -- docker run --rm -v ${CTX}/off.json:/etc/fission/fission.json ${INIT} ${ARCH} ${IMAGE} true
    assert_success
    
    assert_output --partial "> starting"
}
