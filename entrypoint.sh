#!/bin/bash
set -e

# Start WireGuard
echo "[*] Starting WireGuard (${IFACE_NAME})"
wg-quick up /etc/wireguard/${IFACE_NAME}.conf

# Stay alive
tail -f /dev/null

