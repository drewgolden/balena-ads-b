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
        [ -z "$RECEIVER_HOST" ] && echo "Receiver host is missing, halting startup." && missing_variables=true || echo "Receiver host is set: $RECEIVER_HOST"
        [ -z "$RECEIVER_PORT" ] && echo "Receiver port is missing, halting startup." && missing_variables=true || echo "Receiver port is set: $RECEIVER_PORT"
        [ -z "RECEIVER_MLAT_PORT" ] && echo "Receiver MLAT port is missing, halting startup." && missing_variables=true || echo "Receiver MLAT port is set: $RECEIVER_MLAT_PORT"

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

/usr/bin/piaware-config mlat-results-format "beast,connect,${RECEIVER_HOST}:${RECEIVER_MLAT_PORT} beast,listen,30105 ext_basestation,listen,30106"
/usr/bin/piaware-config receiver-type other
/usr/bin/piaware-config receiver-host "${RECEIVER_HOST}"
/usr/bin/piaware-config receiver-port "${RECEIVER_PORT}"

if [ -n "${FLIGHTAWARE_FEEDER_ID}" ]; then
  /usr/bin/piaware-config feeder-id "${FLIGHTAWARE_FEEDER_ID}"
fi

/usr/bin/piaware -plainlog