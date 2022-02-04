setup() {
    # load helper scripts definitions and bats plugins/modules
    # working dir is root test script
    load $(readlink -f "${PWD}")/test_helper/helpers.bash

    # set common environment
    _common_setup
}

@test "empty fission.json file" {
    run --separate-stderr ! -- docker run --rm -v ${CTX}/fission.json:/etc/fission/fission.json -e FISSION_VERBOSE=true ${IMAGE} pstree
}

