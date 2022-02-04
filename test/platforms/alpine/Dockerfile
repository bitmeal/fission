FROM alpine:latest

# add fission init
COPY --from=fission:base / /

# add testing tools
RUN apk add procps psmisc


# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []