# Kinesis Node Gatway Container Image Sources

## How to launch a gateway container

```
# Create a new docker bridge
docker network create \
  --driver=bridge \
  --subnet=192.168.10.0/24 \
  --gateway=192.168.10.1 \
  br-wg0

# Launch a gateway container on 192.168.10.2
docker run -d \
  --name gateway-wg0 \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  --sysctl net.ipv4.ip_forward=1 \
  --network=br-wg0 \
  -e IFACE_NAME=wg0 \
  -v ${PWD}/wg0.conf:/etc/wireguard/wg0.conf:ro \
  -p 51820:51820/udp \
  --ip 192.168.10.2 \
  kinesisorg/gateway-container:latest

# To use this network, point 192.168.10.2 as the default gateway.
```

## How to build an image

docker rmi kinesisorg/gateway-container:latest; \
docker build -t kinesisorg/gateway-container:latest .

docker run -d \
  --name home-gateway \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  --sysctl net.ipv4.ip_forward=1 \
  -v ${PWD}/haproxy.cfg:/etc/haproxy/haproxy.cfg:ro \
  kinesisorg/gateway-container:latest
