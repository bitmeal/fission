#!/bin/sh
TEST_DIR=$(dirname $(readlink -f "$0"))

! docker run --rm -e FISSION_VERBOSE=true fission-init-test pstree
