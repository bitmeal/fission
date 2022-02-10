setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "fission config: silence info logging" {
    run -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json ${IMAGE} true
    assert_success
    
    refute_output
}
