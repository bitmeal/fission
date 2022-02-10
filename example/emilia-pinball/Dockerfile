FROM debian:latest

ARG APT_FLAGS="-q -y --no-install-recommends"
ENV DEBIAN_FRONTEND noninteractive
RUN apt update -q

# debian requires procps package to be installed!
RUN apt install -y procps

# install apps
RUN apt-get install $APT_FLAGS \
	xvfb \
	blackbox \
	x11vnc \
	novnc \
    net-tools \
    pinball pinball-data 

ADD ./pinball.sh /opt/pinball.sh
RUN \
	chmod +x /opt/pinball.sh && \
	mkdir -p /root/.emilia/ && \
	touch /root/.emilia/pinball


# add fission init
COPY --from=ghcr.io/bitmeal/fission:latest / /
ADD ./fission.json /etc/fission/fission.json

# use fission init
ENTRYPOINT ["/opt/fission/bin/fission", "/opt/pinball.sh"]
CMD []