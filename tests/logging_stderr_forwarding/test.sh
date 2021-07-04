#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

COMPARE=$(cat << EOF
[stdout] 01_srv

EOF
)

! docker run --rm -v $TEST_DIR/off.json:/etc/fission/fission.json fission-init-test sleep 2 2>&1 | grep -E '^.+$' &&
test "$(docker run --rm -v $TEST_DIR/on.json:/etc/fission/fission.json fission-init-test sleep 2 2>&1)" = "[stderr] 01_srv"
