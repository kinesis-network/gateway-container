FROM debian:bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
      wireguard haproxy openssh-server \
      iproute2 iptables tcpdump iputils-ping curl \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.backup \
  && mkdir /run/sshd

ENV SSHAUTH=password
ENV IFACE_NAME=wg0

RUN useradd -m -s /bin/bash ssh-agent \
  && echo "ssh-agent:${SSHAUTH}" | chpasswd

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
