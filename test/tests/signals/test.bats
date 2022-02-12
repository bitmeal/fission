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
    swap_stdout_stderr

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
    swap_stdout_stderr

    assert_line --partial '[stderr] [SIGTERM] main'
}

@test "signal forwarding: docker kill -s SIGTERM to main process and aux process" {
    # trigger SIGTERM to main by exiting aux
    CONTAINER_ID=$(mkuuid)
    
    # send SIGTERM in 10 seconds
    ( sleep 10; docker kill -s SIGTERM ${CONTAINER_ID} ) >/dev/null 2>/dev/null &
    # run test container
    run --separate-stderr -- docker run --rm -v ${CTX}/mainaux.json:/etc/fission/fission.json -v ${CTX}/signals.js:/testbin/signals.js --name ${CONTAINER_ID} ${IMAGE} /testbin/signals.js main -- /testbin/signals.js aux
    # assert_success
    
    assert_line --partial '[stdout] [SIGTERM] aux'
    
    # use stderr with bats_assert
    swap_stdout_stderr

    assert_line --partial '[stderr] [SIGTERM] main'
    assert_line --partial '[stderr] [SIGTERM] aux'
}

@test "signal forwarding: to services from docker kill -s SIGTERM; rewriting SIGTERM to SIGHUP for runsvdir" {
    # make log mount
    mkdir -p ${CTX}/bats_test_out

    # trigger SIGTERM to main by exiting aux
    CONTAINER_ID=$(mkuuid)
    
    # send SIGTERM in 10 seconds
    ( sleep 10; docker kill -s SIGTERM ${CONTAINER_ID} ) >/dev/null 2>/dev/null &
    # run test container: make main terminate delayed by 1 second to keep streams open
    run -- docker run --rm -v ${CTX}/bats_test_out/:/var/log/ -v ${CTX}/services.json:/etc/fission/fission.json -v ${CTX}/signals.js:/testbin/signals.js -v ${CTX}/delaysigexit.js:/testbin/delaysigexit.js --name ${CONTAINER_ID} ${IMAGE} /testbin/delaysigexit.js 2000
    assert_success

    # read service logs; console forwarding is to dependant on buffering
    run -- cat ${CTX}/bats_test_out/01_srv/current
    assert_success

    assert_line --partial '[stderr] [SIGTERM] 01_srv'
    assert_line --partial '[stdout] [SIGTERM] 01_srv'

    rm -rf ${CTX}/bats_test_out
}
