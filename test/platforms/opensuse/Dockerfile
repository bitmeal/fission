# allow to pull image from registry by giving build arg
ARG FISSION_BASE="fission:base"
FROM ${FISSION_BASE} AS fission_provider

# build test image
FROM opensuse/leap:latest


# add testing tools
# RUN zypper install -y procps psmisc htop nano tmux
RUN zypper install -y nodejs npm && npm install -g chalk

# add fission init
COPY --from=fission_provider / /

# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []