#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

# aux process outputs to stdout and container stops after aux process exits
! docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json fission-init-test echo fission-init -- sleep 1 | grep -E '^.+$' && \
test $(docker run --rm -v $TEST_DIR/fission.json:/etc/fission/fission.json fission-init-test echo fission-init -- "sleep 1; cat /var/log/app/current" | sed -E 's/^[[:digit:]]{4}(-[[:digit:]]{2}){2}_([[:digit:]]{2}[\.:]){3}[[:digit:]]{5} //') = "fission-init"
