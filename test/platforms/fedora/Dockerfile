FROM fedora:latest


# fedora image is missing setsid, ps and xargs
RUN dnf install -y util-linux procps findutils

# add testing tools
# RUN dnf install -y procps psmisc htop nano tmux
RUN dnf install -y nodejs npm && npm install -g chalk

# add fission init
COPY --from=fission:base / /

# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []