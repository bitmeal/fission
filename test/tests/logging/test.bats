setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "services: logging interlaced stdout/stderr to file with timestamping" {
    # service writes its name to stdout and stderr, redirected to logfile
    # test log for messages from both streams:
    #   - prefixed with timestamp
    #   - prefixed by stream name
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -v ${CTX}/printer.js:/testbin/printer.js ${IMAGE} 'sleep 5; cat /var/log/*/current;'
    assert_success

    # test timestamping
    assert_line --index 0 --regexp '^[[:digit:]]{4}([-_:][[:digit:]]{2}){5}\.[[:digit:]]{5} [[:print:]]+$'
    assert_line --index 1 --regexp '^[[:digit:]]{4}([-_:][[:digit:]]{2}){5}\.[[:digit:]]{5} [[:print:]]+$'

    # test log content and stream names    
    assert_line --index 0 --regexp '^[^[:blank:]]+ \[stdout\] 01_srv$'
    assert_line --index 1 --regexp '^[^[:blank:]]+ \[stderr\] 01_srv$'
    
    assert_equal "${stderr}" ""
}
