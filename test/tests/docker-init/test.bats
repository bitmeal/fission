setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "detect and reuse docker-init from 'docker run --init'" {
    # CTX is test file location
    # IMAGE is docker image:tag for platform to test
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -e FISSION_VERBOSE=true --init ${ARCH} ${IMAGE} ps -f
    assert_success
    
    assert_line --partial 'docker --init'
    assert_line --partial 'docker-init -s -g'
    assert_equal "${stderr}" ""
}
