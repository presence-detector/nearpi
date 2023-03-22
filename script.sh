#!/bin/bash
macAddr=$1;
timeStamp=`date`

while sleep 1;
do
        power=`hcitool rssi $macAddr | cut -d " " -f4`;
        #echo $HOSTNAME | tr '\n' ';' &&  echo $macAddr | tr '\n' ';' && hcitool rssi $macAddr | cut -d " " -f4;

        if [ $power -lt -5 ]
        then
                JSON_STRING=$( jq -n \
                  --arg ho "$HOSTNAME" \
                  --arg ma "$macAddr" \
                  --arg pw "$power" \
                  --arg ts "$timeStamp" \
                  '{location: $ho, macAddress: $ma, power: $pw, timeStamp: $ts}' )
                #echo "Si sta allontanando";
                curl -X POST http://192.168.0.2:1880/test/#flow/da4824d9d2cc87dc -H 'Content-Type: application/json' -d "$JSON_STRING";
        fi
done









