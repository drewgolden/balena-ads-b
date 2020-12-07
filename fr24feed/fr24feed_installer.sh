#!/bin/sh

arch="$(dpkg --print-architecture)"
echo System Architecture: $arch

if [ "$arch" = "arm64" ]; then 
	dpkg --add-architecture armhf
fi

apt-get update && \
	apt-get install -y wget dirmngr gnupg systemd libcap2-bin

cd /tmp

# Import GPG key for the APT repository
mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf
gpg --keyserver pool.sks-keyservers.net --recv-keys 40C430F5
gpg --armor --export 40C430F5 | sudo apt-key add -

# Add APT repository to the config file, removing older entries if exist
mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    grep -v flightradar24 /etc/apt/sources.list.bak > /etc/apt/sources.list && \
    echo 'deb http://repo.feed.flightradar24.com flightradar24 raspberrypi-stable' >> /etc/apt/sources.list
apt-get update && apt-get install -y --no-install-recommends \
    fr24feed=${FR24FEED_VERSION}

apt-get clean && rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*

systemctl disable fr24feed 
rm -rf /etc/systemd/system/fr24feed.service

apt-get purge systemd && apt-get autoremove






