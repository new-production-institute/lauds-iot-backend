# Node-RED and InfluxDB

Already added to this project is [node-red-contrib-influxdb](https://flows.nodered.org/node/node-red-contrib-influxdb). You can use it's nodes to write and query data from an InfluxDB time series database. These nodes support both InfluxDB 1.x and InfluxDb 2.0 databases. At the time of this writing we are using [version 2.6 of InfluxDB on port 8086](http://admin:adminadmin@localhost:8086).

In Node-RED we will be passing the power consumption number through MQTT. 

![Overview](./docs/images/influx-flow.png)

By default this will be passed as a string, so we need to create a function to convert it into a Number before storing it in InfluxDB. 

Add a function node to the page and put the following code into the node:

```JavaScript
msg.payload = Number(msg.payload)
return msg;
```

![Function](./docs/images/influx-function.png)

You can forward this message to InfluxDB. 

![Influx Node](./docs/images/influx-node.png) 

The `URL`of our InfluxDB is `http://influxdb:8086`. In InfluxDB you have to create a `token` to connect: [Load Data -> API Tokens](http://localhost:8086/orgs/721027680173bf2f/load-data/tokens).

![Influx Create Token](./docs/images/influx-create-token.png)

You can use this `token` to create a connection in Node-RED.

![Influx Connection](./docs/images/influx-connection.png)

Then the measurements should be visible in [Influx Data Explorer](http://localhost:8086/orgs/721027680173bf2f/data-explorer?bucket=test).

![Influx Data Explorer](./docs/images/influx-data-explorer.png)

As the data is now stored in Influx, [let's create a dashboard in Grafana](../dashboard/README.md).

# Links

* [IoT Made Easy with Node-RED and InfluxDB](https://www.influxdata.com/blog/iot-easy-node-red-influxdb/)
* A great tutorial can be found at [microcontrollerlab.com](https://microcontrollerslab.com/esp32-mqtt-publish-multiple-sensor-readings-node-red/)



