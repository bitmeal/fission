setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "signal forwarding: main process" {
    # run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -v ${CTX}/signals.sh:/testbin/signals.sh ${IMAGE} /testbin/signals.sh main -- /testbin/signals.sh aux
    run --separate-stderr -- docker run --rm -v ${CTX}/mainaux.json:/etc/fission/fission.json -v ${CTX}/signals.js:/testbin/signals.js ${IMAGE} /testbin/signals.js main -- kill 1
    # assert_success
    
    assert_equal "${output}" "[SIGTERM] main"
    assert_equal "${stderr}" ""
}
