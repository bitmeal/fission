setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "fission config: verbose logging; overriding silent config" {
    # CTX is test file location
    # IMAGE is docker image:tag for platform to test
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -e FISSION_VERBOSE=true ${INIT} ${IMAGE} true
    assert_success
    
    assert_line --partial '# silent: false'
    assert_equal "${stderr}" ""
}
