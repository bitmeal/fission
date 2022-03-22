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

    INIT=$(if ${FISSION_DOCKER_INIT}; then echo "--init"; fi)
    # print "[${BATS_TEST_NAME}] using init flag: ${INIT}"
}

# test for image availability and build if not
_ensure_baseimage() {
    if ! docker image inspect fission:base; then
        docker build -t fission:base .. || (print "error building base docker image"; exit 1)
    fi
}

_ensure_image() {
    if ! docker image inspect ${IMAGE}; then
        _ensure_baseimage
        docker build -t ${IMAGE} platforms/${FISSION_PLATFORM} || (print "error building docker image for ${FISSION_PLATFORM}"; exit 1)
    fi
}

# print to fd 3, prefixed by '#'
# prints from arguments and/or stdin
print() {
    ([ ${#} -ne 0 ] && echo -e "${@}" || cat -) | sed 's/^/# /' >&3
}

swap_stdout_stderr()
{
    output_cache=${output}
    lines_cache=("${lines[@]}")
    
    # use stderr with bats_assert
    output=${stderr}
    lines=("${stderr_lines[@]}")

    # copy stderr back to stdout
    stderr=${output_cache}
    stderr_lines=("${lines_cache[@]}")

    unset output_cache
    unset lines_cache
}

# allow usage of yq for JSON and YAML parsing
yq() {
  docker run --rm -i -v "${PWD}":/workdir mikefarah/yq "$@"
}

# make a uuid
mkuuid() {
    if which uuidgen >/dev/null; then
        echo $(uuidgen)
    else
        if [ -e /proc/sys/kernel/random/uuid ]; then
            echo $(cat /proc/sys/kernel/random/uuid)
        else
            print "could not generate uuid"
            exit 1
        fi
    fi
}