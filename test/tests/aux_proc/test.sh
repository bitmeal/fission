#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

# aux process outputs to stdout and container stops after aux process exits
test $(docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json fission-init-test true -- "sleep 1; echo fission-init") = "fission-init"
