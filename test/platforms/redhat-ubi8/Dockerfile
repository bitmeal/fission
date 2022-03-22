# allow to pull image from registry by giving build arg
ARG FISSION_BASE="fission:base"
FROM ${FISSION_BASE} AS fission_provider

# build test image
FROM redhat/ubi8:latest


# minimal image is missing setsid
# RUN microdnf install util-linux
# is missing 'ps'
RUN dnf -y install procps

# add testing tools
# RUN microdnf install procps psmisc htop nano tmux
RUN dnf -y install nodejs npm && npm install -g chalk

# add fission init
COPY --from=fission_provider / /

# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []