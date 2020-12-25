#!/usr/bin/env bash
set -e

# Verify that all the required varibles are set before starting up the application.

missing_variables=true

echo "Validating settings..."
echo " "
sleep 2

while [ "$missing_variables" = true ]; do 
        missing_variables=false
        
        # Begin defining all the required configuration variables.

        [ -z "$LAT" ] && echo "Receiver latitude is missing, halting startup." && missing_variables=true || echo "Receiver latitude is set: $LAT"
        [ -z "$LON" ] && echo "Receiver longitude is missing, halting startup." && missing_variables=true || echo "Receiver longitude is set: $LON"

        # End defining all the required configuration variables.

        echo " "
        
        if [ "$missing_variables" = true ]
        then
                echo "Settings missing, halting startup for 60 seconds..."
                echo " "
                sleep 60
        fi
done

echo "Settings verified, proceeding with startup."
echo " "

# Variables are verified – continue with startup procedure.

# Turn on bash's job control
set -m
  
# Start dump1090-fa and put it in the backgroun
/usr/bin/dump1090-fa --lat "%(ENV_LAT)" --lon "%(ENV_LON)" --fix --device-index 0 --gain -10 --ppm 0 --max-range 360 --net --net-heartbeat 60 --net-ro-size 1000 --net-ro-interval 1 --net-http-port 0 --net-ri-port 0 --net-ro-port 30002 --net-sbs-port 30003 --net-bi-port 30004,30104 --net-bo-port 30005 --json-location-accuracy 2 --write-json /run/dump1090-fa --quiet &
  
# Start lighthttpd and put it in the background
/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf &
 
# Wait for any services to exit
wait -n

