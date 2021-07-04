#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

test $(docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json fission-init-test echo "\${FOO}-\${BAR}") = "fission-init"
