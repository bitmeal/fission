#!/usr/bin/env bash

## test for docker
if ! docker --version > /dev/null ; then
    echo "docker executable not found!" >2
    exit 1
fi

## test for and checkout bats
if ! bats/bin/bats --version > /dev/null ; then
    echo "# bats not found; checking out submodules"
    git submodule update --init --recursive &> /dev/null
fi

## test for platform
if [ -z "${FISSION_PLATFORM}" ]; then
    echo "# FISSION_PLATFORM not specified; using alpine"
    export FISSION_PLATFORM="alpine"
fi

## check if want to use docker-init (docker run --init)
if [ -z "${FISSION_DOCKER_INIT}" ]; then
    echo "# FISSION_DOCKER_INIT not specified; using own init"
    export FISSION_DOCKER_INIT=false
fi

## check for architecture
if [ ! -z "${FISSION_ARCH}" ]; then
    echo "# FISSION_ARCH: using architecture ${FISSION_ARCH}"
fi


## run tests
export LC_COLLATE=C
bats/bin/bats ${@} -r ./tests