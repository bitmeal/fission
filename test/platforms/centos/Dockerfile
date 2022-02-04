FROM centos:latest

# add fission init
COPY --from=fission:base / /

# add testing tools
RUN \
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-* && \
    yum install -y procps psmisc


# use fission init
ENTRYPOINT ["/opt/fission/bin/fission"]
CMD []