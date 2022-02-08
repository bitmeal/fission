setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "services: run services" {
    run --separate-stderr -- docker run --rm -v ${CTX}/services.json:/etc/fission/fission.json ${IMAGE} "sleep 5; ls -l /test_out"
    assert_success
    
    assert_line --partial '01_srv'
    assert_line --partial '02_srv'

    assert_equal "${stderr}" ""
}

@test "services: no runsvdir errors without services" {
    run -- docker run --rm -v ${CTX}/no_services.json:/etc/fission/fission.json ${IMAGE} sleep 5
    assert_success

    refute_output
}
