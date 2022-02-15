FROM alpine:latest


# add testing tools
# RUN apk add procps psmisc htop nano tmux
RUN apk add nodejs npm && npm install -g chalk

# add fission init
COPY --from=fission:base / /

# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []