setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "services: stderr forwarding [ON]" {

    run --separate-stderr -- docker run --rm -v ${CTX}/on.json:/etc/fission/fission.json ${IMAGE} sleep 2
    assert_success
    
    refute_output
    assert_equal "${stderr}" "[stderr] 01_srv"
}

@test "services: stderr forwarding [OFF]" {

    run -- docker run --rm -v ${CTX}/off.json:/etc/fission/fission.json ${IMAGE} sleep 2
    assert_success
    
    refute_output
}
