setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "arguments: fail and show usage on EMPTY main command" {
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -e FISSION_VERBOSE=true ${INIT} ${IMAGE}
    assert_failure
    
    assert_line --index 0 --regexp '^usage:.*$'
    assert_equal "${stderr}" ""
}

@test "arguments: fail and show usage on EMPTY main command + EMPTY aux command" {
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -e FISSION_VERBOSE=true ${INIT} ${IMAGE} --
    assert_failure
    
    assert_line --index 0 --regexp '^usage:.*$'
    assert_equal "${stderr}" ""
}

@test "arguments: fail and show usage on EMPTY main command + aux command" {
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -e FISSION_VERBOSE=true ${INIT} ${IMAGE} -- true
    assert_failure
    
    assert_line --index 0 --regexp '^usage:.*$'
    assert_equal "${stderr}" ""
}

@test "arguments: success on main command + -- [EMPTY aux command]" {
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -e FISSION_VERBOSE=true ${INIT} ${IMAGE} true --
    assert_success
    
    assert_line --partial 'starting main process'
    assert_equal "${stderr}" ""
}
