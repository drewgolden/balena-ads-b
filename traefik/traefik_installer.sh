#!/bin/sh

arch="$(dpkg --print-architecture)"
echo System Architecture: $arch

if [ "$arch" = "arm64" ]; then 
	traefik_arch="arm64"
elif [ "$arch" = "amd64" ]; then 
	traefik_arch="amd64"
else 
	traefik_arch="armv5" 
fi

traefik_packet="traefik_v${TRAEFIK_VERSION}_linux_$traefik_arch.tar.gz"

cd /tmp/ && wget --quiet -O traefik.tar.gz "https://github.com/containous/traefik/releases/download/v${TRAEFIK_VERSION}/$traefik_packet"; 

tar -C /usr/bin/ -zxvf traefik.tar.gz && rm traefik.tar.gz

chmod +x /usr/bin/traefik