setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "environment variables" {
    run --separate-stderr -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json ${IMAGE} echo "\${FOO}-\${BAR}"

    assert_equal "${output}" "fission-init"
    assert_equal "${stderr}" ""
}
