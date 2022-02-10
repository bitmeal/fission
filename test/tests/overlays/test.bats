setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "config overlays: add to config" {
    run -- docker run --rm -v ${CTX}/add.json:/etc/fission/fission.json -v ${CTX}/overlays_add/:/etc/fission/overlays/ ${IMAGE} echo '${FOO}-${BAR}'
    assert_success
    
    assert_output "fission-init"
}

@test "config overlays: remove from config (key: null)" {
    run -- docker run --rm -v ${CTX}/rm.json:/etc/fission/fission.json -v ${CTX}/overlays_rm/:/etc/fission/overlays/ ${IMAGE} echo '${FOO}-${BAR}'
    assert_success
    
    # need to inhibit option parsing '--', otherwise bats will wait for compare string from stdin
    assert_output -- "-"
}
