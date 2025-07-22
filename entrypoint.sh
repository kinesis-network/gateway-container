#!/bin/bash
set -e

if [ -f /etc/haproxy/haproxy.cfg ]; then
  echo "[*] Starting HAProxy"
  haproxy -f /etc/haproxy/haproxy.cfg &
fi

if [ -f /etc/wireguard/${IFACE_NAME}.conf ]; then
  echo "[*] Starting WireGuard (${IFACE_NAME})"
  wg-quick up /etc/wireguard/${IFACE_NAME}.conf
fi

# Stay alive
tail -f /dev/null
