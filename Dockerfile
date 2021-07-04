FROM alpine


RUN apk add pstree

# add fission init
RUN apk add dumb-init runit jq
COPY fission /usr/bin/fission
RUN chmod +x /usr/bin/fission


ENTRYPOINT ["/usr/bin/fission"]
CMD []