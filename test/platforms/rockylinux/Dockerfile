# allow to pull image from registry by giving build arg
ARG FISSION_BASE="fission:base"
FROM ${FISSION_BASE} AS fission_provider

# build test image
FROM rockylinux:latest


# rockylinux image is missing ps and xargs
RUN dnf install -y procps findutils

# add testing tools
# RUN dnf install -y procps psmisc htop nano tmux
RUN dnf install -y nodejs npm && npm install -g chalk

# add fission init
COPY --from=fission_provider / /

# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []