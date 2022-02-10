setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

# @test "signal forwarding: main process with aux - kill 1" {
#     # calling sh -c needs cheating with "'cmd'"
#     run --separate-stderr -- docker run --rm -v ${CTX}/mainaux.json:/etc/fission/fission.json -v ${CTX}/signals.js:/testbin/signals.js ${IMAGE} /testbin/signals.js main -- sh -c "'sleep 2; kill 1; tail -F /var/log/app/current 2>/dev/null'"
#     assert_success

#     assert_line --partial '[stdout] [SIGTERM] main'
#     assert_line --partial '[stderr] [SIGTERM] main'
# }

@test "signal forwarding: exiting aux process signals SIGTERM to main; assert stderr forwarding mechanism lifetime" {
    # trigger SIGTERM to main by exiting aux
    run --separate-stderr -- docker run --rm -v ${CTX}/mainaux.json:/etc/fission/fission.json -v ${CTX}/signals.js:/testbin/signals.js ${IMAGE} /testbin/signals.js main -- sleep 2
    assert_success
    
    refute_output

    # use stderr with bats_assert
    output=${stderr}
    lines=${stderr_lines}

    assert_line --partial '[stderr] [SIGTERM] main'
}

@test "signal forwarding: docker kill -s SIGTERM to main process" {
    # trigger SIGTERM to main by exiting aux
    CONTAINER_ID=$(mkuuid)
    
    # send SIGTERM in 10 seconds
    ( sleep 10; docker kill -s SIGTERM ${CONTAINER_ID} ) &
    # run test container
    run --separate-stderr -- docker run --rm -v ${CTX}/mainaux.json:/etc/fission/fission.json -v ${CTX}/signals.js:/testbin/signals.js --name ${CONTAINER_ID} ${IMAGE} /testbin/signals.js main    


    assert_success
    
    assert_line --partial '[stdout] [SIGTERM] main'

    # use stderr with bats_assert
    output=${stderr}
    lines=${stderr_lines}

    assert_line --partial '[stderr] [SIGTERM] main'
}

@test "signal forwarding: docker kill -s SIGTERM to main process and aux process" {
    # trigger SIGTERM to main by exiting aux
    CONTAINER_ID=$(mkuuid)
    
    # send SIGTERM in 10 seconds
    ( sleep 10; docker kill -s SIGTERM ${CONTAINER_ID} ) &
    # run test container
    run --separate-stderr -- docker run --rm -v ${CTX}/mainaux.json:/etc/fission/fission.json -v ${CTX}/signals.js:/testbin/signals.js --name ${CONTAINER_ID} ${IMAGE} /testbin/signals.js main -- /testbin/signals.js aux
    

    assert_success
    
    assert_line --partial '[stdout] [SIGTERM] aux'

    # use stderr with bats_assert
    output=${stderr}
    lines=${stderr_lines}

    # fails with assert_line !?
    assert_output --partial '[stderr] [SIGTERM] main'
    assert_output --partial '[stderr] [SIGTERM] aux'
}
