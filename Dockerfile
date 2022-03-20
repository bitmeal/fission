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
            cp /tini/tini . && \
            cp /runit/admin/runit-${RUNIT_VER}/command/* .

    WORKDIR /


# build distribution container
FROM scratch
    WORKDIR /
    COPY --from=builder /opt/fission/bin /opt/fission/bin
