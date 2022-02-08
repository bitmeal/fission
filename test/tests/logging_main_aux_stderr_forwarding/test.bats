setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "aux process: main stderr forwarding [ON]" {
    run --separate-stderr -- docker run --rm -v ${CTX}/on.json:/etc/fission/fission.json ${IMAGE} 'echo fission-init >&2' -- sleep 1
    assert_success
    
    refute_output
    assert_equal "${stderr}" "fission-init"
}

@test "aux process: main stderr forwarding [OFF]" {
    run -- docker run --rm -v ${CTX}/off.json:/etc/fission/fission.json ${IMAGE} 'echo fission-init >&2' -- sleep 1
    assert_success
    
    refute_output
}
