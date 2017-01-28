FROM phusion/baseimage:0.9.18
MAINTAINER Bhanu Nemani <bhanu@hopperbee.com>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y gdebi-core

ENV COTURN_VER 4.5.0.4
RUN cd /tmp/ && curl -sL http://turnserver.open-sys.org/downloads/v${COTURN_VER}/turnserver-${COTURN_VER}.tar.gz | tar -xzv

RUN groupadd turnserver
RUN useradd -g turnserver turnserver
RUN dpkg-buildpackage
RUN gdebi -n /tmp/coturn*.deb

RUN mkdir /etc/service/turnserver
COPY turnserver.sh /etc/service/turnserver/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
