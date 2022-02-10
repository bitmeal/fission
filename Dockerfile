# build and fetch statically linked dependencies
FROM alpine:latest as builder


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
ARG JQ_VER=tags/jq-1.6
RUN \
    curl -L $(curl -L https://api.github.com/repos/stedolan/jq/releases/${JQ_VER} | jq -r '.assets[] | select(.name | match(".*linux.*64")) | .browser_download_url') > jq && \
    chmod +x jq

WORKDIR /pid1
ARG PID1_VER=tags/pid1-0.1.3.0
RUN \
    curl -L $(curl -L https://api.github.com/repos/fpco/pid1/releases/${PID1_VER} | jq -r '.assets[] | select(.name | match(".*linux.*64")) | .browser_download_url') > pid1.tar.gz && \
    tar -xzpf pid1.tar.gz && \
    chmod +x sbin/pid1

WORKDIR /dumb-init
ARG DUMB_INIT_VER=tags/v1.2.5
RUN \
    curl -L $(curl -L https://api.github.com/repos/Yelp/dumb-init/releases/${DUMB_INIT_VER} | jq -r '.assets[] | select(.name | match(".*x86_64")) | .browser_download_url') > dumb-init && \
    chmod +x dumb-init

WORKDIR /tini
ARG TINI_VER=tags/v0.19.0
RUN \
    curl -L $(curl -L https://api.github.com/repos/krallin/tini/releases/${TINI_VER} | jq -r '.assets[] | select(.name | match("^tini-static-muslc-amd64$")) | .browser_download_url') > tini && \
    chmod +x tini

WORKDIR /opt/fission/bin
ADD fission .
RUN \
    chmod +x fission && \
    cp /jq/jq . && \
    cp /pid1/sbin/pid1 . && \
    cp /dumb-init/dumb-init . && \
    cp /tini/tini . && \
    cp /runit/admin/runit-${RUNIT_VER}/command/* .

WORKDIR /


# build distribution container
FROM scratch

WORKDIR /

COPY --from=builder /opt/fission/bin /opt/fission/bin
