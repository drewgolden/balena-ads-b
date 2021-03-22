#!/usr/bin/env bash
set -e

# Check if service has been disabled through the DISABLED_SERVICES environment variable.

if [[ ",$(echo -e "${DISABLED_SERVICES}" | tr -d '[:space:]')," = *",$BALENA_SERVICE_NAME,"* ]]; then
        echo "$BALENA_SERVICE_NAME is manually disabled."
        sleep infinity
fi

# Verify that all the required varibles are set before starting up the application.

echo "Verifying settings..."
echo " "
sleep 2

missing_variables=false
        
# Begin defining all the required configuration variables.

[ -z "$ADSB_EXCHANGE_SITENAME" ] && echo "ADS-B Exchange username is missing, will abort startup." && missing_variables=true || echo "ADS-B Exchange username is set: $ADSB_EXCHANGE_SITENAME"
[ -z "$ADSB_EXCHANGE_UUID" ] && echo "ADS-B Exchange UUID is missing, will abort startup." && missing_variables=true || echo "ADS-B Exchange UUID is set: $ADSB_EXCHANGE_UUID"
[ -z "$LAT" ] && echo "Receiver latitude is missing, will abort startup." && missing_variables=true || echo "Receiver latitude is set: $LAT"
[ -z "$LON" ] && echo "Receiver longitude is missing, will abort startup." && missing_variables=true || echo "Receiver longitude is set: $LON"
[ -z "$ALT" ] && echo "Receiver altitude is missing, will abort startup." && missing_variables=true || echo "Receiver altitude is set: $ALT"
[ -z "$RECEIVER_HOST" ] && echo "Receiver host is missing, will abort startup." && missing_variables=true || echo "Receiver host is set: $RECEIVER_HOST"
[ -z "$RECEIVER_PORT" ] && echo "Receiver port is missing, will abort startup." && missing_variables=true || echo "Receiver port is set: $RECEIVER_PORT"

# End defining all the required configuration variables.

echo " "

if [ "$missing_variables" = true ]
then
        echo "Settings missing, aborting..."
        echo " "
        sleep infinity
fi

echo "Settings verified, proceeding with startup."
echo " "

# Write settings to config file and set permissions.
envsubst < /boot/adsbx-uuid.tpl > /boot/adsbx-uuid
chmod a+rw /boot/adsbx-uuid

# Variables are verified – continue with startup procedure.

while sleep 30
do
	if ping -q -c 2 -W 5 feed.adsbexchange.com >/dev/null 2>&1
	then
	
	echo Connected to feed.adsbexchange.com:"${RECEIVER_PORT:-30005}"
                echo Feeding from "${RECEIVER_HOST}:${RECEIVER_PORT}"
		socat -u TCP:"${RECEIVER_HOST}:${RECEIVER_PORT:-30005}" TCP:feed.adsbexchange.com:"${RECEIVER_PORT:-30005}"
		echo Disconnected
	else
		echo Unable to connect to feed.adsbexchange.com, trying again in 30 seconds!
	fi
done
