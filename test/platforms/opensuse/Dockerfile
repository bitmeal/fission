# build runit and fetch dumb-init
FROM opensuse/leap AS builder

ARG RUNIT_VER=2.1.2

RUN zypper install -y curl tar gzip make gcc glibc-static jq

WORKDIR /runit
RUN \
    curl -OL http://smarden.org/runit/runit-${RUNIT_VER}.tar.gz && \
    tar -xpf runit-${RUNIT_VER}.tar.gz && \
    cd admin/runit-${RUNIT_VER}/ && \
    ./package/compile && ./package/check && \
    mkdir -p /runit_pkg && cp command/* /runit_pkg/ && chmod +x /runit_pkg/*

WORKDIR /dumb-init
RUN \
    curl -L $(curl -L https://api.github.com/repos/Yelp/dumb-init/releases/latest | jq -r '.assets[] | select(.name | match(".*x86_64")) | .browser_download_url') > dumb-init && \
    chmod +x dumb-init


FROM opensuse/leap
COPY --from=builder /dumb-init/dumb-init /usr/local/bin/
COPY --from=builder /runit_pkg/* /usr/local/bin/

# add fission init
RUN zypper install -y jq && zypper clean --all
# COPY fission /usr/bin/fission
# RUN chmod +x /usr/bin/fission


# ENTRYPOINT ["/usr/bin/fission"]
# CMD []