FROM alpine

# add fission init
COPY fission /usr/bin/fission
RUN \
    chmod +x /usr/bin/fission && \
    apk add dumb-init runit jq && \
    mkdir -p /etc/service

COPY services.json /etc/container_env/services.json
RUN apk add pstree

ENTRYPOINT ["/bin/ash", "/usr/bin/fission"]
CMD []