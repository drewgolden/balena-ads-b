#!/bin/sh

# Verify that all the required varibles are set before starting up the application.

missing_variables=true

echo "Validating settings..."
echo " "
sleep 2

while [ "$missing_variables" = true ]; do 
        missing_variables=false
        
        # Begin defining all the required configuration variables.

        [ -z "$PLANEFINDER_SHARECODE" ] && echo "Plane Finder Sharecode is missing, halting startup." && missing_variables=true || echo "Plane Finder Sharecode is set: $PLANEFINDER_SHARECODE"
        [ -z "$LAT" ] && echo "Receiver latitude is missing, halting startup." && missing_variables=true || echo "Receiver latitude is set: $LAT"
        [ -z "$LON" ] && echo "Receiver longitude is missing, halting startup." && missing_variables=true || echo "Receiver longitude is set: $LON"
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

echo "Settings verified, proceeding with startup."
echo " "


# Variables are verified – continue with startup procedure.

envsubst < /etc/pfclient-config.json.tpl> /etc/pfclient-config.json
/usr/bin/pfclient --config_path=/etc/pfclient-config.json --log_path=/dev/console