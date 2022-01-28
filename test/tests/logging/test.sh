#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

COMPARE=$(cat << EOF
[stdout] 01_srv
[stderr] 01_srv
EOF
)

RESULT=$(docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json fission-init-test "sleep 5; cat /var/log/*/current;" | sed -E 's/^[[:digit:]]{4}(-[[:digit:]]{2}){2}_([[:digit:]]{2}[\.:]){3}[[:digit:]]{5} //')

test "${RESULT}" = "${COMPARE}"
