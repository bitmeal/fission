# allow to pull image from registry by giving build arg
ARG FISSION_BASE="fission:base"
FROM ${FISSION_BASE} AS fission_provider

# build test image
FROM ubuntu:latest


ENV DEBIAN_FRONTEND=noninteractive
RUN apt update

# add testing tools
# RUN apt install -y procps psmisc htop nano tmux
RUN apt install -y --no-install-recommends nodejs npm && npm install -g chalk

# add fission init
COPY --from=fission_provider / /

# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []