#!/bin/bash

backup_directory="~/volume_backup"
mkdir -p ${backup_directory}
cd ${backup_directory}

for container in "nodered" "jupyter" "grafana" "influxdb" "interfacer_api" "mosquitto"
do
        mkdir -p ${container}
        cd ${container}
        docker run --rm --volumes-from ${container} -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /data
        cd ..
done

cd -
