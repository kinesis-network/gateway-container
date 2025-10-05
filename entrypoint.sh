#!/bin/bash
set -e

if [ -f /etc/haproxy/haproxy.cfg ]; then
  echo "[*] Starting HAProxy"
  haproxy -f /etc/haproxy/haproxy.cfg &
fi

if [ -f /etc/wireguard/${IFACE_NAME}.conf ]; then
  if lsmod | grep -q iptable_nat; then
    echo "[*] Enabling iptables-legacy as default"
    update-alternatives --set iptables /usr/sbin/iptables-legacy
  fi
  echo "[*] Starting WireGuard (${IFACE_NAME})"
  wg-quick up /etc/wireguard/${IFACE_NAME}.conf
fi

/usr/sbin/sshd -D
