#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

# aux process outputs to stdout and container stops after aux process exits
! docker run --rm -v $TEST_DIR/off.json:/etc/fission/fission.json fission-init-test "echo fission-init >&2" -- sleep 1 2>&1 | grep -E '^.+$' && \
test $(docker run --rm -v $TEST_DIR/on.json:/etc/fission/fission.json fission-init-test "echo fission-init >&2" -- sleep 1 2>&1) = "fission-init"
