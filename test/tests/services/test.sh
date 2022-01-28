#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

COMPARE=$(cat << EOF
/root/01_srv
/root/02_srv
EOF
)

RESULT=$(docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json fission-init-test "sleep 5; find /root -type f -maxdepth 1 | sort | sed 's#\./##' | grep -v '^\.'")

test "${RESULT}" = "${COMPARE}"
