#!/bin/sh

arch="$(dpkg --print-architecture)"
echo System Architecture: $arch

if [ "$arch" = "arm64" ]; then 
	dpkg --add-architecture armhf
	fr24feed_arch=armhf
	fr24feed_url="https://repo-feed.flightradar24.com/rpi_binaries/"
	
elif [ "$arch" = "amd64" ]; then 
	fr24feed_arch=amd64
	fr24feed_url="https://repo-feed.flightradar24.com/linux_x86_64_binaries/"
else 
	fr24feed_arch=armhf
	fr24feed_url="https://repo-feed.flightradar24.com/rpi_binaries/"
fi

apt-get update && \
	apt-get install -y wget

cd /tmp

fr24feed_installer="fr24feed_${FR24FEED_VERSION}_$fr24feed_arch.tgz" 
wget -O fr24feed.tgz $fr24feed_url$fr24feed_installer
tar xf fr24feed.tgz --strip-components 1
cp fr24feed /usr/bin
chmod +x /usr/bin/fr24feed

apt-get clean && rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*

apt-get autoremove