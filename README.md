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

If Docker UI is preferred, you can optionally use [Docker Desktop](https://www.docker.com/products/docker-desktop/).


## Installation

### Setting up Raspberry Pi
- Download and Install Raspberry Pi Imager
    - https://www.raspberrypi.com/software/
- Connect your microSD card to your computer using a card reader.
- Make sure the card is empty or that you have backed up any important data, as this process will erase everything on it.
- Open the Imager program.
- Click CHOOSE DEVICE and select Raspberry Pi DEVICE.
- Click CHOOSE OS and select Raspberry Pi OS (64 bit).
- Click CHOOSE STORAGE and select your microSD card.
- Configure Advanced Options (Optional but Recommended)

    - Click the gear icon (or press Ctrl+Shift+X) to open OS Customisation.
    - Here you can:
        - Enable SSH for remote access under services.

        - Set a username and password (required in newer Raspberry Pi OS versions).

        - Enter Wi-Fi SSID and password for headless setup.

        - Set hostname, locale, keyboard layout, and timezone.

- Write the Image
- Wait for the program to write and verify the image. This can take several minutes.
- Eject the Card
- Insert the card into your Raspberry Pi.
- First Boot
    - Power on your Raspberry Pi with the card inserted.
    - If you enabled Wi-Fi and SSH, you can connect remotely without a monitor.
    - Otherwise, connect a monitor and keyboard to complete setup.
### Setting up Lauds stack.
### Clone the Repository

```sh
git clone https://github.com/dyne/lauds-iot-backend.git
cd lauds-iot-backend
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

