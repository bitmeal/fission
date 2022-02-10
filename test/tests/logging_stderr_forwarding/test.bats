setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "services: stderr forwarding [ON] - empty stdout" {

    run --separate-stderr -- docker run --rm -v ${CTX}/on.json:/etc/fission/fission.json -v ${CTX}/printer.js:/testbin/printer.js ${IMAGE} sleep 2
    assert_success
    
    refute_output
}

@test "services: stderr forwarding [ON] - msg on stderr" {

    run -- docker run --rm -v ${CTX}/on.json:/etc/fission/fission.json -v ${CTX}/printer.js:/testbin/printer.js ${IMAGE} sleep 2
    assert_success
    
    assert_line "[stderr] 01_srv"
}

@test "services: stderr forwarding [OFF]" {

    run -- docker run --rm -v ${CTX}/off.json:/etc/fission/fission.json -v ${CTX}/printer.js:/testbin/printer.js ${IMAGE} sleep 2
    assert_success
    
    refute_output
}
