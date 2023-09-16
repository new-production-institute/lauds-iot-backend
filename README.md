# IoT Prototyping Backend

## Overview

This project is a backend solution for prototyping Internet of Things (IoT) services. It leverages the power of Docker containers to easily integrate Grafana, InfluxDB, and Node-RED into a seamless, scalable, and robust backend system. The solution aims to provide rapid prototyping capabilities for IoT applications that need real-time data visualization, storage, and workflow automation.

## Features

* [Eclipse Mosquitto](https://mosquitto.org): MQTT broker
* [Grafana](https://grafana.com/): Real-time data visualization and monitoring dashboard
* [InfluxDB](https://www.influxdata.com/): High-performance data storage
* [Node-RED](https://nodered.org/): Flow-based development tool for visual programming and data flow automation

## Prerequisites

* [Docker](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Installation

```sh
git clone https://github.com/your-repo/iot-backend-prototyping.git
cd iot-backend-prototyping
```

Launch Docker Containers

bash

docker-compose up -d


## Docker

First install DockerDesktop and `docker-compose`:

- https://www.docker.com/products/docker-desktop/
- https://docs.docker.com/compose/install/

```sh
docker-compose --file software/container/docker-compose.yml up
```

### Mosquitto

[Eclipse Mosquitto](https://mosquitto.org) is an open source message broker which implements a server for MQTT. It runs in Docker and is exposed on the default MQTT port `1883`. You can subscribe to and push into `topics`: 

```sh
mosquitto_sub -h localhost -t '#' -p 1883
mosquitto_pub -h localhost -p 1883 -t '/' -m $(date --utc +%s)
```

There is also a *very* usefuly tool to debug MQTT: [MQTT Explorer](https://github.com/thomasnordquist/MQTT-Explorer/), that is also available at [mqtt-explorer.com](https://mqtt-explorer.com/).

### Node-RED

[Node-RED](https://nodered.org) is a programming tool for wiring together hardware devices, APIs and online services in new and interesting ways.

It provides a browser-based editor that makes it easy to wire together flows using the wide range of nodes in the palette that can be deployed to its runtime in a single-click

NodeRed is also running in Docker: http://localhost:1880/

A simple introduction to Node-RED can be found - along with the nodes / the code -  in [this repository, please have a look](./software/flow/README.md)! 

### InfluxDB

[InfluxDB](https://www.influxdata.com) is a database for any time series data with a single. It runs in Docker and is exposed on port `8086`:

InfluxDb is running here: http://localhost:8086/ (admin:adminadmin)

### Grafana

[Grafana](https://grafana.com) is a software to build operational dashboards. It runs in Docker and is exposed on port `3000`:

You can login to Grafana: http://localhost:3000/login (admin:admin)

Have a look at the [HowTo in this repository](./software/dashboard/README.md).
