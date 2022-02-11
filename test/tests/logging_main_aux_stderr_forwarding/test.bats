setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "aux process: main stderr forwarding [ON]" {
    run --separate-stderr -- docker run --rm -v ${CTX}/on.json:/etc/fission/fission.json -v ${CTX}/echo_stderr.sh:/testbin/echo_stderr.sh ${IMAGE} /testbin/echo_stderr.sh -- sleep 1
    assert_success
    
    refute_output

    swap_stdout_stderr

    assert_line --partial "fission-init"
}

@test "aux process: main stderr forwarding [ON] prefixed by '[main]'" {
    run --separate-stderr -- docker run --rm -v ${CTX}/on.json:/etc/fission/fission.json -v ${CTX}/echo_stderr.sh:/testbin/echo_stderr.sh ${IMAGE} /testbin/echo_stderr.sh -- sleep 1
    assert_success
    
    refute_output

    swap_stdout_stderr

    assert_line --regexp '^\[main\]'
}

@test "aux process: main stderr forwarding [OFF]" {
    run -- docker run --rm -v ${CTX}/off.json:/etc/fission/fission.json  -v ${CTX}/echo_stderr.sh:/testbin/echo_stderr.sh ${IMAGE} /testbin/echo_stderr.sh -- sleep 1
    assert_success
    
    refute_output
}
