setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "aux process: run and stop container on exit" {
    # aux process outputs to stdout and container stops after aux process exits
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json ${IMAGE} true -- "sleep 1; echo fission-init"
	assert_success

    assert_equal "${output}" "fission-init"
    assert_equal "${stderr}" ""
}
