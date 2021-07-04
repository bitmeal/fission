#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

# test sourcing behavior from init scripts
test "$(docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json -v $TEST_DIR/source.sh:/testbin/source.sh fission-init-test 'echo ${SOURCED_VAR}')" = "fission-init"
