#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

# test for no output, when valid primary command is given

! docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json fission-init-test true | grep -E '^.+$'
