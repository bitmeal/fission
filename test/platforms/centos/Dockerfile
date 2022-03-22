# allow to pull image from registry by giving build arg
ARG FISSION_BASE="fission:base"
FROM ${FISSION_BASE} AS fission_provider

# build test image
FROM centos:latest


RUN \
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
    # yum install -y epel-release

# add testing tools
# RUN yum install -y procps psmisc htop nano tmux
RUN yum install -y nodejs npm && npm install -g chalk

# add fission init
COPY --from=fission_provider / /

# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []