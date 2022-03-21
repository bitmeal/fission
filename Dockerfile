# syntax=docker/dockerfile:1.3
# requires buildx/buildkit-backend

# build and fetch statically linked dependencies
FROM alpine:latest as builder
    ARG TARGETPLATFORM

    RUN apk add alpine-sdk curl jq

    WORKDIR /runit
        ARG RUNIT_VER=2.1.2
        RUN \
            curl -OL http://smarden.org/runit/runit-${RUNIT_VER}.tar.gz && \
            tar -xzpf runit-${RUNIT_VER}.tar.gz && \
            cd admin/runit-${RUNIT_VER}/ && \
            echo 'gcc -no-pie -static' > src/conf-ld && \
            ./package/compile && ./package/check && \
            chmod +x command/*

    WORKDIR /jq
        ARG JQ_VER=jq-1.6
        # no arm builds are supplied, so we build from source
        RUN \
            if [ -z "${TARGETPLATFORM}" ]; then \
                TARGETPLATFORM="$(uname -m)" ; \
            fi ; \
            if [ -z "${TARGETPLATFORM##*arm64*}" -o -z "${TARGETPLATFORM##*aarch64*}" ]; then \
                echo "building jq from source for ARM"; \
                apk add git libtool automake autoconf && \
                git clone https://github.com/stedolan/jq jq_source && cd jq_source && \
                git checkout ${JQ_VER} && \
                git submodule update --init --recursive && \
                autoreconf -fi && \
                ./configure --with-oniguruma=builtin --disable-maintainer-mode && \
                make LDFLAGS=-all-static && \
                make check && \
                cp jq ../jq ; \
            else \
                curl -L $(curl -L https://api.github.com/repos/stedolan/jq/releases/tags/${JQ_VER} | jq -r '.assets[] | select(.name | match(".*linux.*64")) | .browser_download_url') > jq && \
                chmod +x jq ; \
            fi

    WORKDIR /tini
        ARG TINI_VER=v0.19.0
        RUN \
            if [ -z "${TARGETPLATFORM}" ]; then \
                TARGETPLATFORM="$(uname -m)" ; \
            fi ; \
            if [ -z "${TARGETPLATFORM##*arm64*}" -o -z "${TARGETPLATFORM##*aarch64*}" ]; then \
                echo "selecting tini for ARM"; \
                export TINI_ARCH_SELECTOR='^tini-static-arm64$' ; \
            else \
                export TINI_ARCH_SELECTOR='^tini-static-muslc-amd64$' ; \
            fi && \
            curl -L $(curl -L https://api.github.com/repos/krallin/tini/releases/tags/${TINI_VER} | jq --arg ARCH "${TINI_ARCH_SELECTOR}" -r '.assets[] | select(.name | match($ARCH)) | .browser_download_url') > tini && \
            chmod +x tini

    WORKDIR /opt/fission/bin
        ADD fission .
        RUN \
            chmod +x fission && \
            cp /jq/jq . && \
            cp /tini/tini . && \
            cp /runit/admin/runit-${RUNIT_VER}/command/* .

    WORKDIR /


# build distribution container
FROM scratch
    WORKDIR /
    COPY --from=builder /opt/fission/bin /opt/fission/bin
