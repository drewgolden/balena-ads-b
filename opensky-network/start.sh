#!/bin/sh

# Verify that all the required varibles are set before starting up the application.

missing_variables=true

echo "Validating settings..."
echo " "
sleep 2

while [ "$missing_variables" = true ]; do 
        missing_variables=false
        
        # Begin defining all the required configuration variables.

        [ -z "$OPENSKY_USERNAME" ] && echo "OpenSky Network Username is missing, halting startup." && missing_variables=true || echo "OpenSky Network Username is set: $OPENSKY_USERNAME"
        [ -z "$LAT" ] && echo "Receiver latitude is missing, halting startup." && missing_variables=true || echo "Receiver latitude is set: $LAT"
        [ -z "$LON" ] && echo "Receiver longitude is missing, halting startup." && missing_variables=true || echo "Receiver longitude is set: $LON"
        [ -z "$ALT" ] && echo "Receiver altitude is missing, halting startup." && missing_variables=true || echo "Receiver altitude is set: $ALT"
        [ -z "$RECEIVER_HOST" ] && echo "Receiver host is missing, halting startup." && missing_variables=true || echo "Receiver host is set: $RECEIVER_HOST"
        [ -z "$RECEIVER_PORT" ] && echo "Receiver port is missing, halting startup." && missing_variables=true || echo "Receiver port is set: $RECEIVER_PORT"

        # End defining all the required configuration variables.

        echo " "
        
        if [ "$missing_variables" = true ]
        then
                echo "Settings missing, halting startup for 60 seconds..."
                echo " "
                sleep 60
        fi
done

envsubst < /var/lib/openskyd/conf.tpl/10-debconf.conf.tpl> /var/lib/openskyd/conf.d/10-debconf.conf

missing_variables=true

echo "Looking for OpenSky Network Serial..."
echo " "
sleep 2

while [ "$missing_variables" = true ]; do 
        missing_variables=false
        
        # Begin defining all the required configuration variables.

        [ -z "$OPENSKY_SERIAL" ] && echo "OpenSky Network Serial is missing, halting startup." && missing_variables=true || echo "OpenSky Network Serial is set: $OPENSKY_SERIAL"

        # End defining all the required configuration variables.

        echo " "
        
        if [ "$missing_variables" = true ]
        then
                echo "OpenSky Network Serial is missing, halting startup for 60 seconds..."
                echo " "
                sleep 60
        fi
done

envsubst < /var/lib/openskyd/conf.tpl/05-serial.conf.tpl> /var/lib/openskyd/conf.d/05-serial.conf

echo "Settings verified, proceeding with startup."
echo " "

# Variables are verified – continue with startup procedure.


/usr/bin/openskyd-dump1090
