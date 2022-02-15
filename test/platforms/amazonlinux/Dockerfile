FROM amazonlinux:latest


# setsid is missing
RUN yum install -y util-linux

# add testing tools
# RUN yum install -y procps psmisc htop nano tmux
RUN \
    curl -sL https://rpm.nodesource.com/setup_16.x | bash && \
    yum install -y nodejs npm && npm install -g chalk

# add fission init
COPY --from=fission:base / /

# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []