#!/usr/bin/env bash

_common_setup() {
    # print ${PWD}
    load $(readlink -f "${PWD}")/test_helper/bats-support/load.bash
    load $(readlink -f "${PWD}")/test_helper/bats-assert/load.bash

    # CTX="$( cd "$( dirname "${BATS_TEST_FILENAME}" )" >/dev/null 2>&1 && pwd )"
    CTX=$(readlink -f "${BATS_TEST_DIRNAME}")
    # print "[${BATS_TEST_NAME}] context in: ${CTX}"

    IMAGE="fission:${FISSION_PLATFORM}"
    # print "[${BATS_TEST_NAME}] using image: ${IMAGE}"
}

# test for image availability and build if not
_ensure_baseimage() {
    if ! docker image inspect fission:base; then
        docker build -t fission:base .. || (print "error building base docker image"; exit 1)
    fi
}

_ensure_image() {
    _ensure_baseimage
    
    if ! docker image inspect ${IMAGE}; then
        docker build -t ${IMAGE} platforms/${FISSION_PLATFORM} || (print "error building docker image for ${FISSION_PLATFORM}"; exit 1)
    fi
}

# print to fd 3, prefixed by '#'
# prints from arguments and/or stdin
print() {
    ([ ${#} -ne 0 ] && echo -e "${@}" || cat -) | sed 's/^/# /' >&3
}

# allow usage of yq for JSON and YAML parsing
yq() {
  docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"
}