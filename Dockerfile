FROM debian:stretch

LABEL maintainer Knut Ahlers <knut@ahlers.me>

# Get the SHA256 from https://www.teamspeak.com/en/downloads#server
ENV TEAMSPEAK_VERSION=3.11.0 \
    TEAMSPEAK_SHA256=18c63ed4a3dc7422e677cbbc335e8cbcbb27acd569e9f2e1ce86e09642c81aa2

SHELL ["/bin/bash", "-exo", "pipefail",  "-c"]
RUN apt-get update \
 && apt-get install -y curl bzip2 ca-certificates --no-install-recommends \
 && curl -sSfLo teamspeak3-server_linux-amd64.tar.bz2 \
      "https://files.teamspeak-services.com/releases/server/${TEAMSPEAK_VERSION}/teamspeak3-server_linux_amd64-${TEAMSPEAK_VERSION}.tar.bz2" \
 && echo "${TEAMSPEAK_SHA256} *teamspeak3-server_linux-amd64.tar.bz2" | sha256sum -c - \
 && tar -C /opt -xjf teamspeak3-server_linux-amd64.tar.bz2 \
 && rm teamspeak3-server_linux-amd64.tar.bz2 \
 && apt-get purge -y curl bzip2 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY docker-ts3.sh /opt/docker-ts3.sh

# Inject a Volume for any TS3-Data that needs to be persisted or to be accessible from the host. (e.g. for Backups)
VOLUME ["/teamspeak3"]

CMD ["/opt/docker-ts3.sh"]

# Expose the Standard TS3 port, for files, for serverquery
EXPOSE 9987/udp 30033 10011
