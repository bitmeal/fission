#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

test $(docker run --rm -v $TEST_DIR/add.json:/etc/fission/fission.json -v $TEST_DIR/overlays_add/:/etc/fission/overlays/ fission-init-test echo "\${FOO}-\${BAR}") = "fission-init" && \
test $(docker run --rm -v $TEST_DIR/rm.json:/etc/fission/fission.json -v $TEST_DIR/overlays_rm/:/etc/fission/overlays/ fission-init-test echo "\${FOO}-\${BAR}") = "-"
