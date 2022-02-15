FROM opensuse/leap:latest


# add testing tools
# RUN zypper install -y procps psmisc htop nano tmux
RUN zypper install -y nodejs npm && npm install -g chalk

# add fission init
COPY --from=fission:base / /

# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []