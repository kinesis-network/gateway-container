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

# A per-gateway password, when the deployer passes one; the image's default otherwise.
# A bad value keeps the default rather than stopping the gateway (set -e).
if [ -n "${SSH_PASSWORD:-}" ]; then
  case "$SSH_PASSWORD" in
    *$'\n'*) echo "[!] SSH_PASSWORD holds a newline; keeping the default" ;;
    *) printf 'ssh-agent:%s\n' "$SSH_PASSWORD" | chpasswd || echo "[!] chpasswd failed; keeping the default" ;;
  esac
fi

/usr/sbin/sshd -D
