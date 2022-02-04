FROM opensuse/leap:latest

# add fission init
COPY --from=fission:base / /

# add testing tools
RUN zypper install -y procps psmisc


# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []