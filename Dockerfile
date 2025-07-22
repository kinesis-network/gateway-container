FROM debian:bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
      wireguard iproute2 iptables tcpdump iputils-ping haproxy curl \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV IFACE_NAME=wg0

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.backup

CMD ["/entrypoint.sh"]

