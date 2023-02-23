# IoT Platform

## Docker

First install DockerDesktop and `docker-compose`:

- https://www.docker.com/products/docker-desktop/
- https://docs.docker.com/compose/install/

Then you can export a path to mount as a volume and spin up the containers:

```sh
export DATA_DIR = /some/path/to/mount
docker-compose --file software/container/docker-compose.yml up
```

### Mosquitto

```sh
mosquitto_sub -h localhost -t '#' -p 1883
mosquitto_pub -h localhost -p 1883 -t '/' -m $(date --utc +%s)
```

### Node-RED

NodeRed is running here: http://localhost:1880/

A simple introduction to Node-RED can be found - along with the nodes / the code -  in [this repository, please have a look](./software/flow/README.md)! 

### InfluxDB

InfluxDb is running here: http://localhost:8086/

### Grafana

You can login to Grafana: http://localhost:3000/login (admin:admin)

Have a look at the [HowTo in this repository](./software/dashboard/README.md).


## Hardware

We are using HelTec Automation Wirelsess Sticks ESP32 Dev-Boards.

See the [documentation in this repository](./hardware/README.md).

## Hardware sensors

* [Energy Monitor](./software/firmware/energy-monitor/README.md)
* [Shelly Example](./software/firmware/shelly-monitor/README.md)