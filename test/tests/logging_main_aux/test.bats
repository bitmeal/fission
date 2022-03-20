setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "aux process: main process redirected to logfile (no output on stdout)" {
    run -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json ${INIT} ${IMAGE} echo fission-init -- sleep 1
    assert_success

    refute_output
}

@test "aux process: main process redirected to logfile (output in logfile)" {
    # calling sh -c needs cheating with "'cmd'"
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json ${INIT} ${IMAGE} echo fission-init -- sh -c "'sleep 1; cat /var/log/app/current'"
    assert_success
    
    assert_line --index 0 --partial 'fission-init'
    assert_equal "${stderr}" ""
}
