setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "exit code forwarding: foreground main" {
    run -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json ${IMAGE} exit 0
	assert_success

    run -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json ${IMAGE} exit 1
	assert_failure
}

@test "exit code forwarding: foreground aux" {
    run -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json ${IMAGE} true -- exit 0
	assert_success

    run -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json ${IMAGE} true -- exit 1
	assert_failure
}
