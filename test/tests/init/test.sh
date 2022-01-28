#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

COMPARE=$(cat << EOF
init 01
init 99_sub/01
init 99_sub/10
init 01
EOF
)

# execute init scripts from directories or commands/scripts
test "$(docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json -v $TEST_DIR/init.d/:/testbin/init.d/ fission-init-test true)" = "${COMPARE}"
