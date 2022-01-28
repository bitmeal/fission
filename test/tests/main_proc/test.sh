#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

# main process outputs to stdout and container stops after main process exits
test $(docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json fission-init-test echo "fission-init") = "fission-init"
