# IoT Prototyping Backend

## Overview

This project is a backend solution for prototyping Internet of Things (IoT) services. It leverages the power of Docker containers to easily integrate Grafana, InfluxDB, and Node-RED into a seamless, scalable, and robust backend system. The solution aims to provide rapid prototyping capabilities for IoT applications that need real-time data visualization, storage, and workflow automation.

## Features

* [Eclipse Mosquitto](https://mosquitto.org): MQTT broker
* [Grafana](https://grafana.com/): Real-time data visualization and monitoring dashboard
* [InfluxDB](https://www.influxdata.com/): High-performance data storage
* [NodeRED](https://nodered.org/): Flow-based development tool for visual programming and data flow automation
* [Jupyter Notebook](https://jupyter.org/): a web application for creating and sharing computational documents
* [Interfacer API](https://github.com/interfacerproject/Interfacer-notebook): an API for ingestion into the Interfacer application

## Architecture overview

Data is collected by IoT devices, e.g. an ESP32 based power monitor. These devices *publish* their data via MQTT into a topic in a message broker. We use Eclipse Mosquitto as a MQTT message broker.

Node-RED is used to read and transform or combine data and to implement more sophicsticated use cases like notifications or worksflow. Node-RED *subscribes* to topics in Mosquitto and can be used to save transformed data into a database.

As our data is bases on time, we are using a *time series database* to store information. We used InfluxDB as this database.

Dashboards can already be created in Node-RED, but to be more flexible (and include more options) we are using Grafana. Grafana reads data from our *database* and *other sources* (like CSV files on the Internet) and displays them in a nice dashboard.

## Prerequisites

### Docker

First install Docker and `docker-compose`:

* [Docker](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Installation

### Prepare SD Card Image of Devuan Pi Operating System

- Download the Daedalus arm64 image zipfile for the Raspberry Pi 5 (nightly builds)[https://arm-files.devuan.org/RaspberryPi%20Latest%20Builds/] on the Devuan ARM files site (the zipfile begins with `rpi-5-devuan-daedalus-` and ends with `.zip`.

- Transfer the image to the SD card using your prefered disk tool.

- Insert the SD card into the Devuan RPi5.

- Power up the Devuan RPi5, log in (devuan/devuan) and ensure the Raspberry Pi is connected to your network (either through the ethernet interface or you must configure the WiFi details for your local network).

- Ensure the SSH daemon is running on the Devuan RPi5.

- Note down the IP address allocated to the Devuan RPi5.

- On the ansible provisioning host, generate an SSH key pair and add the public key to the RPi5 root SSH authorized_keys configuration file `/root/.ssh/authorized_keys`.

### Clone the Repository on the Ansible Provisioning Host

```sh
git clone https://github.com/dyne/lauds-iot-backend.git
cd lauds-iot-backend/ansible
```

### Provisioning via ansible

#### Remote ansible preparation

- On the ansible provisioning host a hostname and local IP address must be uniquely defined for the Devuan Pi in the `inventory.yml` file (eg, a host configuration example for `flirc-rpi5` is the repo is `)

The unique hostname should be related to the LAUDS factory sitename or consortium member name.

- Individual host VPN IP address configuration is configured in `ansible/host_vars/` with the configuration file matching the hostname (eg, the host configuration example file in the repo is `ansible/host_vars/flirc-pi5`):

```sh
client_ip_addr: 192.168.10.[address]
```
where [address] is a unique host address allocated to your install.

#### Remote ansible provisioning

On the ansible provisioning host:

```sh
source ../.env && ansible-playbook -i inventory.yml playbook.yml
```

### Configure local credentials

Create file `.env` to set default credentials

```sh
# NodeRed admin user password
export NR_ADMIN_PW="<your NR admin user login password>"
# Jupyter Notebook token
export JUPYTER_TOKEN="<your Jupyter Notebook login token>"
```


### Build and launch Docker containers

Most Docker containers are off-the-shelf, but the Node-RED container is built with some useful plugins included. To build and run these Docker containers in a single step:

Assuming required credentials above are set in `.env`

```sh
source .env && docker-compose --file software/container/docker-compose.yml up --force-recreate --build
```

## Usage

### Mosquitto

[Eclipse Mosquitto](https://mosquitto.org) is an open source message broker which implements a server for MQTT. It runs in Docker and is exposed on the default MQTT port `1883`. You can subscribe to and push into `topics`: 

```sh
mosquitto_sub -h localhost -t '#' -p 1883
mosquitto_pub -h localhost -p 1883 -t '/' -m $(date --utc +%s)
```

A useful tool to debug MQTT is  [MQTT Explorer](https://mqtt-explorer.com/) found on [Github](https://github.com/thomasnordquist/MQTT-Explorer/).

### Node-RED

[Node-RED](https://nodered.org) is a low-code programming tool for wiring together hardware devices, APIs and online services in new and interesting ways.

It provides a browser-based editor that makes it easy to wire together flows using the wide range of nodes in the palette that can be deployed to its runtime in a single-click.

Node-RED is also running in Docker and is exposed on port `1880`: http://localhost:1880/

### InfluxDB

[InfluxDB](https://www.influxdata.com) is a database for any time series data. It runs in Docker and is exposed on port `8086`: http://localhost:8086/ (you have to create an initial user in just a few simple steps)

### Grafana

[Grafana](https://grafana.com) is visualisation software for building operational dashboards. It runs in Docker and is exposed on port `3000`:

You can login to Grafana: http://localhost:3000/login (admin:admin)

### Jupyter Notebook

[Jupyter Notebook](https://jupyter.org/) is a web application for creating and sharing computational documents.

### Interfacer API

[Interfacer API](https://github.com/interfacerproject/Interfacer-notebook) is an API service for interacting with the [Interfacer Project](https://interfacerproject.dyne.org/)

## Examples and set-up

### Setting up a simple flow in Node-RED

A simple introduction to Node-RED can be found - along with the nodes / the code -  in [this repository](./docs/flow/README.md).

### Connecting Node-RED to Influx

A more sophisticated exampe on how to connect Node-RED to influx is also available in [this repository](./docs/flow/docs/node-influx.md).


### Setting up Grafana

Have a look at the [the document in this repository](./docs/dashboard/README.md).


### Attaching a Shelly plug

As an example you can use a Shelly plug flashed with Tasmota and feed MQTT data with Node-RED into InfluxDB and visualize it with Grafana. Have a look, [here](./docs/shelly/README.md).

## Backup und hosting

This is just a prototype. You should not expose the services as-it-is to the public internet.

Also you have to think about a backup solution. At the moment data lives in Docker volumes, that could be backed up:

* influxdb2: The time series database
* grafana-dashboards: Grafana dashboards 
* grafana-data: Grafana data 
* nodered-data: Flows created in Node-RED

## Contribution

Feel free to open an issue for bugs, feature requests, or questions. Contributions are welcome.

## License

This project follows the [REUSE Specification](https://reuse.software/spec/) and is licensed under the [GPL 3.0 or later License - see the LICENSE file](./LICENSES/GPL-3.0-or-later.txt) for details.

