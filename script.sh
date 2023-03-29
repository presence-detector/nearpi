#!/bin/bash
#macAddr=2C:BE:EB:17:CB:B3;
macAddr=$1;
timeStamp=`date`;
pi=`hciconfig | grep "BD Address:" | cut -d " " -f 3`
while sleep 1;
do
        power=`hcitool rssi $macAddr | cut -d " " -f4`;
        echo $HOSTNAME | tr '\n' ';' &&  echo $macAddr | tr '\n' ';' && hcitool rssi $macAddr | cut -d " " -f4;
        re='^[0-9]+$';
        if ! [[ $power =~ $re ]]
        then
                p=99
                power=$((p))
                JSON_STRING=$( jq -n \
                --arg ho "$HOSTNAME" \
                --arg ma "$macAddr" \
                --arg pi "$pi" \
                --arg pw "$power" \
                --arg ts "$timeStamp" \
                '{location: $ho, macAddressPhone: $ma, macAddressPi: $pi, power: $pw, timeStamp: $ts}' )
                echo "Si sta allontanando";
                curl -X POST http://192.168.0.2:1880/test/#flow/da4824d9d2cc87dc -H 'Content-Type: application/json' -d>
        else
                JSON_STRING=$( jq -n \
                --arg ho "$HOSTNAME" \
                --arg ma "$macAddr" \
                --arg pi "$pi" \
                --arg pw "$power" \
                --arg ts "$timeStamp" \
                '{location: $ho, macAddressPhone: $ma, macAddressPi: $pi, power: $pw, timeStamp: $ts}' )
                #echo "Si sta allontanando";
                curl -X POST http://192.168.0.2:1880/test/#flow/da4824d9d2cc87dc -H 'Content-Type: application/json' -d>
        fi                                                                                                              
done
