setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "init: exporting environment sourced in init scripts" {
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -v ${CTX}/source.sh:/testbin/source.sh ${INIT} ${ARCH} ${IMAGE} sh -c 'echo ${SOURCED_VAR}'
    assert_success
    
    assert_equal "${output}" "fission-init"
    assert_equal "${stderr}" ""
}
