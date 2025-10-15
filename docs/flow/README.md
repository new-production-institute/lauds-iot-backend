# Node-RED general introduction

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

## Plugins


Node-RED uses plugins. You can access the plugins in the right burger menu. We already added  plugins for InfluxDB, an aggregator/tranformer from watt to kwh and capabilites for Node-RED's own Dashboard capabilites, so you don't have to add them.

![Plugins](./docs/images/node-red-plugins.png)

Of course you can install more plugins in this section, but it's better, to add them to [package.json](../../software/flow/package.json) and build a new Docker image using the [Dockerfile](../../software/flow/Dockerfile) provided in this project. 

## First steps

For debuging you can add Node-RED's own dashboard (sure, we are going to use Grafana, later).

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

Have a look at the flow also in [this repository](./docs/00-dashboard-example/dashboard.json).

You can also [connect to InfluxDB](./docs/node-influx.md).


# Node-RED LAUDS Gateway configuration

In the following steps we will describe the confgiration steps to adapt the [template flow](software/flow/flows.json) to the local LAUDS setup. As machine example we use PRUSALink API and for energy sensor we use Shelly Power Plug.

## Template example for Prusa 3D printer and Shelly energy sensor
![](https://pad.fabcity.hamburg/uploads/5371346e-0f6f-4f14-8a5c-e6a0a5b36851.png)
### Flow Descriptions
- **Machine Configurations**
    - This section initializes the machine’s configuration when the flow starts.
    - Purpose: Sets up essential device parameters (like printer name, IP, or type) used throughout the flow.
    - Key Nodes:
        - Inject (“Set machine config once”) — triggers once on deployment.
        - Function (“set device config”) — defines and stores configuration data for later use.
- **Prusa Printer Flow**
    - Handles communication with the Prusa 3D printer and collects printer status data.
    - Purpose: calls the printer’s API every second to monitor print status, progress, and other telemetry.
    - Key Nodes:
        - Inject (“RUN”) — starts the polling process.
        - Trigger (“resend every 1s”) — continuously sends requests to the printer.
        - Function (“url for printer status”) — builds the API URL for status requests.
        - HTTP Request (“prusa printer status”) — fetches live printer data.
        - Function (“Store Machine Data”) — processes and formats the received data.
        - Debug (“Prusa printer telemetry”) — displays the live telemetry in Node-RED.
        - Function (“structure job process and machine process for influx”) — formats the results to store in InfluxDB.
        - InfluxDB nodes — store structured machine process and job process data in the database.
- **Calculate the Energy Consumption Per Print**
    - Computes how much energy the printer consumes for each completed job.
    - Purpose: Integrates power readings with printer data to estimate energy usage per print.
    - Key Nodes:
        - Function (“Input require variables”) — gathers the necessary inputs (enegy, machinestate, job info).
        - Function (“Calculate Energy Per Print”) — performs the actual calculation.
        - Debug (“Energy Per Print”) — outputs the result for verification.
        - Function (“structure job for influx”) — formats the results to store in InfluxDB.
- **Energy Sensor Flow**
    - Captures real-time power and energy data from a Shelly energy sensor.
    - Purpose: Collects energy readings, stores them, and makes them available for consumption calculations.
    - Key Nodes:
        - Input (“Shelly Data”) — receives data from the Shelly power sensor.
        - Function (“structure for influx”) — structures data for database storage.
        - InfluxDB output — stores power telemetry.
        - Function (“store current energy”) — keeps the latest energy reading for use in calculations.
        - Debug (“Shelly telemetry”) — displays live energy sensor data.
- **Data structure for InfluxDB**
    - Retrieves configuration data from the Node-RED flow context (machine_config_data).
    - Maps incoming payload data to match the InfluxDB data structure.
    - Formats the data as an array of measurement objects for InfluxDB.
    - Each object includes:
        - measurement – specifies the data source type (e.g., “machine”, “sensor”).
        - fields – holds dynamic payload values (e.g., printer data, energy readings).
        - tags – adds metadata such as device ID, brand, and type from configuration.
    - Supports multiple data inputs (e.g., machine data or energy sensor data).
    - Ensures consistent and configurable data formatting before writing to InfluxDB.
    - examples structure from template
    ![](https://pad.fabcity.hamburg/uploads/f811a3c5-8df4-4443-9120-7b01d07c8cf1.png)
    ![](https://pad.fabcity.hamburg/uploads/92a734f1-06ac-46ea-881a-435c8a85f331.png)


### Steps to setup the flow:
- **Step 1:** set the device configurations by editing the ```set device config function``` node and add the required fields (```deviceId```, ```ipAddress```, ```devicetype```, ```devicebrand```, ```electricaldeviceid```, ```electricaldevicetype```, ```electricaldevicebrand```)as in the example below.
    ![](https://pad.fabcity.hamburg/uploads/dbd05849-e14b-47b6-a3c0-c2d6d31cc683.png)

- **Step 2:** set the authentication for the prusa printer in the  ```http request``` node ```prusa printer status``` by selecting ```use authentication```, ```type of authentification```= ```digest authentication```, ```username``` (example: maker) and ```password```.
    ![](https://pad.fabcity.hamburg/uploads/5071a270-eed9-4934-a6a7-5f05ef9598a9.png)
- **Step 3:** set the ```influxdb``` node to store all the data into the influx db
    - set up influxdb server by enterig the ```URL``` of the influxdb server and ```Token``` in the fields.
    ![](https://pad.fabcity.hamburg/uploads/723381a5-574b-48de-9d2e-4ee7f619ecde.png)
    - after the server is set up enter the ```Organization``` and ```Bucket``` name as specified in the InfluxDB.
        ![](https://pad.fabcity.hamburg/uploads/ef565c37-bb84-479e-a94b-8383bfdfc81b.png)
- **Step 4:** set up the shelly data in ```mqtt-broker``` node
    - edit the ```Server``` field by clicking the pencil symbol, set up the MQTT ```Server``` and ```Port``` to which selly is publishing data (example: ```192.168.188.124```, ```1883```)
        ![](https://pad.fabcity.hamburg/uploads/1319f9b4-1c77-47c1-8ad4-e2dcf99c44fe.png)
    - set up the ```Topic``` to which shelly is publishing data (example: ```SPPS-05/status/switch:0```)
    ![](https://pad.fabcity.hamburg/uploads/6a4a9543-3f91-439a-aa32-687cd014cd54.png)