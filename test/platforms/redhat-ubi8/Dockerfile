FROM redhat/ubi8:latest


# minimal image is missing setsid
# RUN microdnf install util-linux
# is missing 'ps'
RUN dnf -y install procps

# add testing tools
# RUN microdnf install procps psmisc htop nano tmux
RUN dnf -y install nodejs npm && npm install -g chalk

# add fission init
COPY --from=fission:base / /

# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []