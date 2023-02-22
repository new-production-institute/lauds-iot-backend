#!/bin/sh
echo Publishing random values to topic '/iot-platform/energy-monitor/test-device‘
while true  
do
    mosquitto_pub -h localhost -p 1883 -t '/iot-platform/energy-monitor/test-device/watt' -m  $((1 + $RANDOM % 10 * 500))
    printf '%s' "."
    sleep 1  
done