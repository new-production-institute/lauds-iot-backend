# About

> This folder will be mounted into the Node-RED runtime. So be careful.

# Node-RED

If you boot up our tech stack using `docker-compose` you already have a Node-RED instance running on [your local machine](http://localhost:1880/).

Node-RED is an open-source, low-code, visual programming tool based on the concept of flow-based development. The idea behind it is to make it very easy to connect APIs, hardware devices, and anything else accessible over some type of network connection.

## Core Concepts

Nodes are the important part of Node-Red. They are the building blocks when working with Node-Red. Nodes are triggered by either receiving a message object from a previous node or an external event like an MQTT event. The node processes the message or event and then passes it on to the next node.

A node can:
* Inject: Starts a flow by injecting a message or a payload.
* Change: Here you can do basic transformation or modification on the message object.
* Debug: Can be used to help developing flows by sending messages to the side bar.
* Switch: Here you can add logic (like sending the message to different nodes).
* Function: Add custom JavaScript for uses cases where simple nodes do not do the trick.

Flows are an organized sequence of nodes. Let's do the "first steps" by creating a simple flow.

## First steps

For debuging I already added Node-RED's own dashboard (sure, we are going to use Grafana, later).

![Overview](./docs/images/1-overview.png)

The dashboard should be visible on the righmost menu item in Node-RED.

![Dashboard item](./docs/images/dashboard.png)

In Node-RED you can add a MQQT node to receive values from the power monitor. As we run in `docker-compose`you don't have to use the IP address of our Eclipse Mosquitto sever, but you can simply use `mosquitto` as the host nome.

![MQTT Node](./docs/images/2-mqtt-node.png)git a

To simply display the values in a gauge (or chart) you can hook it up to a gauge node.

 ![Gauge Node](./docs/images/3-gauge-node.png) 

In the dasboard section you have to create a tab. Inside this tab you have to create a group. 

![Dashboard Settings](./docs/images/4-dashboard-node.png)

The tricky part is putting the gauges in the group. This is done in the gauge's settings (not in the dashboard's settings).

![Gauge Node](./docs/images/3-gauge-node.png) 

You can view the dashboard in an (also mobile) web browser.

![Mobile view](./docs/images/5-dashboard.png)

Have a look at the flow also in [this repository](./00-dashboard-example/dashboard.json).

## InfluxDB

Already added to this project is [node-red-contrib-influxdb](https://flows.nodered.org/node/node-red-contrib-influxdb). You can use it's nodes to write and query data from an InfluxDB time series database. These nodes support both InfluxDB 1.x and InfluxDb 2.0 databases. At the time of this writing we are using [version 2.6 of InfluxDB on port 8086](http://admin:adminadmin@localhost:8086).

In Node-RED we will be passing the power consumption number through MQTT. 

![Overview](./docs/images/influx-flow.png)

By default this will be passed as a string, so we need to create a function to convert it into an integer before storing it in InfluxDB. 

Add a function node to the page and put the following code into the node:

```JavaScript
msg.payload = Number(msg.payload)
return msg;
```

![Function](./docs/images/influx-function.png)

You can forward this message to InfluxDB. 

![Influx Node](./docs/images/influx-node.png) 

The `URL`of our InfluxDB is `http://influxdb:8086`. In InfluxDB you have to create a `token` to connect: [Load Data -> API Tokens](http://localhost:8086/orgs/721027680173bf2f/load-data/tokens).

![Influx Connection](./docs/images/influx-connection.png)

Then the measurements should be visible in [Influx Data Explorer](http://localhost:8086/orgs/721027680173bf2f/data-explorer?bucket=test).

![Influx Data Explorer](./docs/images/influx-data-explorer.png)

# Links

* [IoT Made Easy with Node-RED and InfluxDB](https://www.influxdata.com/blog/iot-easy-node-red-influxdb/)
* A great tutorial can be found at [microcontrollerlab.com](https://microcontrollerslab.com/esp32-mqtt-publish-multiple-sensor-readings-node-red/)



