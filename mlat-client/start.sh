#!/bin/sh

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
        [ -z "$ALT" ] && echo "Receiver altitude is missing, halting startup." && missing_variables=true || echo "Receiver altitude is set: $ALT"
        [ -z "$MLAT_CLIENT_USER" ] && echo "MLAT client username is missing, halting startup." && missing_variables=true || echo "MLAT Client Username is set: $MLAT_CLIENT_USER"
        [ -z "$MLAT_SERVER" ] && echo "MLAT server is missing, halting startup." && missing_variables=true || echo "MLAT server is set: $MLAT_SERVER"
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

/usr/bin/mlat-client --input-type dump1090 --input-connect $RECEIVER_HOST:$RECEIVER_PORT --lat $LAT --lon $LON --alt $ALT --user $MLAT_CLIENT_USER --server $MLAT_SERVER 