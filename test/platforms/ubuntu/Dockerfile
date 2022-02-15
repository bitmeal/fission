FROM ubuntu:latest


ENV DEBIAN_FRONTEND=noninteractive
RUN apt update

# add testing tools
# RUN apt install -y procps psmisc htop nano tmux
RUN apt install -y --no-install-recommends nodejs npm && npm install -g chalk

# add fission init
COPY --from=fission:base / /

# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []