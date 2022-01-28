FROM ubuntu

# add fission init
RUN \
    apt update && \
    apt install -y dumb-init runit jq && \
    rm -rf /var/lib/apt/lists/*
# COPY fission /usr/bin/fission
# RUN chmod +x /usr/bin/fission


# ENTRYPOINT ["/usr/bin/fission"]
# CMD []