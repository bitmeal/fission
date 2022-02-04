FROM ubuntu:latest

# add fission init
COPY --from=fission:base / /

# add testing tools
RUN \
    apt update && \
    apt install -y procps psmisc


# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []