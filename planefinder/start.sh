#!/bin/sh

# Verify that all the required varibles are set before starting up the application.

missing_variables=true

echo "Validating settings..."
echo " "
sleep 2

while [ "$missing_variables" = true ]; do 
        missing_variables=false
        
        # Begin defining all the required configuration variables.

        [ -z "$PLANEFINDER_SHARECODE" ] && echo "Plane Finder Sharecode not set, holding startup" && missing_variables=true || echo "Plane Finder Sharecode set"
        [ -z "RECEIVER_HOST" ] && echo "Receiver host not set, holding startup" && missing_variables=true || echo "Receiver host set"
        [ -z "RECEIVER_PORT" ] && echo "Receiver port not set, holding startup" && missing_variables=true || echo "Receiver port set"
        [ -z "LAT" ] && echo "Receiver latitude not set, holding startup" && missing_variables=true || echo "Receiver latitude set"
        [ -z "LON" ] && echo "Receiver longitude not set, holding startup" && missing_variables=true || echo "Receiver longitude set"

        # End defining all the required configuration variables.

        echo " "
        
        if [ "$missing_variables" = true ]
        then
                echo "Missing settings, waiting 60 seconds..."
                echo " "
                sleep 60
        fi
done

echo "Settings verified, proceeding with startup."
echo " "


# Variables are verified – continue with startup procedure.

envsubst < /etc/pfclient-config.json.tpl> /etc/pfclient-config.json
/usr/bin/pfclient --config_path=/etc/pfclient-config.json --log_path=/dev/console