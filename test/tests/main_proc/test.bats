setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "main: outputs to stdout and container stops after main process exits" {
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json ${INIT} ${IMAGE} echo 'fission-init'
    assert_success
    
    assert_equal "${output}" "fission-init"
    assert_equal "${stderr}" ""
}
