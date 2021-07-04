#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

# test for no output, when valid primary command is given

docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json -e FISSION_VERBOSE=true fission-init-test | grep -E '^usage:' && \
docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json -e FISSION_VERBOSE=true fission-init-test --  | grep -E '^usage:'
