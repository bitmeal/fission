#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

! docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json -e FISSION_VERBOSE=true fission-init-test pstree
