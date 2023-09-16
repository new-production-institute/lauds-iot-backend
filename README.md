# IoT Prototyping Backend

## Overview

This project is a backend solution for prototyping Internet of Things (IoT) services. It leverages the power of Docker containers to easily integrate Grafana, InfluxDB, and Node-RED into a seamless, scalable, and robust backend system. The solution aims to provide rapid prototyping capabilities for IoT applications that need real-time data visualization, storage, and workflow automation.

## Features

* [Eclipse Mosquitto](https://mosquitto.org): MQTT broker
* [Grafana](https://grafana.com/): Real-time data visualization and monitoring dashboard
* [InfluxDB](https://www.influxdata.com/): High-performance data storage
* [Node-RED](https://nodered.org/): Flow-based development tool for visual programming and data flow automation

## Prerequisites

### Docker

First install Docker and `docker-compose`:

* [Docker](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

If you want to use an UI for Docker, you can optionally also use [Docker Desktop](https://www.docker.com/products/docker-desktop/).

## Installation

### Clone the Repository

```sh
git clone https://code.curious.bio/simonox/iot-backend
cd iot-backend
```

### Build and launch Docker containers

Most Docker containers are of the shelf, but the Node-RED container has the be built, so some usefull plugins are already included. You can build and run these Docker containers in a single step:

```sh
docker-compose --file software/container/docker-compose.yml up --force-recreate --build
```

## Usage

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

Node-RED is also running in Docker and is exposed on port `1880`: http://localhost:1880/

### InfluxDB

[InfluxDB](https://www.influxdata.com) is a database for any time series data with a single. It runs in Docker and is exposed on port `8086`: http://localhost:8086/ (you have to create an initial user in just a few simple steps)

### Grafana

[Grafana](https://grafana.com) is a software to build operational dashboards. It runs in Docker and is exposed on port `3000`:

You can login to Grafana: http://localhost:3000/login (admin:admin)


## Examples and set-up

### Setting up a simple flow in Node-RED

A simple introduction to Node-RED can be found - along with the nodes / the code -  in [this repository](./docs/flow/README.md).

### Connecting Node-RED to Influx

A more sophisticated exampe on how to connect Node-RED to influx is also available in [this repository](./docs/flow/docs/node-influx.md).


### Setting up Grafana

Have a look at the [the document in this repository](./docs/dashboard/README.md).


### Attaching a Shelly plug

As an example you can use a Shelly plug flashed with Tasmota and feed MQTT data with Node-RED into InfluxDB and visualize it with Grafana. Have a look, [here](./docs/shelly/README.md).

## Contribution

Feel free to open an issue for bugs, feature requests, or questions. Contributions are welcome.

## License

This project follows the [REUSE Specification](https://reuse.software/spec/) and is licensed under the [GPL 3.0 or later License - see the LICENSE file](./LICENSES/GPL-3.0-or-later.txt) for details.