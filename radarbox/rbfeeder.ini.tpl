[client]
network_mode=true
key=${RADARBOX_KEY}
stn=${RADARBOX_STATION_ID}
lat=${LAT}
lon=${LON}
alt=${ALT}

[network]
mode=beast
external_host=${RECEIVER_HOST}
external_port=${RECEIVER_PORT}

[mlat]
autostart_mlat=true