# About

> This folder will be mounted into the Node-RED runtime. So be careful.

# Node-RED

If you boot up our tech stack using `docker-compose` you already have a Node-RED instance running on [your local machine](http://localhost:1880/).

## First steps

For debuging I allready Node-RED's own dashboard (sure, we are going to use Grafana, later).

![Overview](./docs/images/1-overview.png)

The dashboard should be visible on the righmost menu item in Node-RED.

![Dashboard item](./docs/images/dashboard.png)

In Node-RED you can add a MQQT node to receive values from the power monitor. As we run in `docker-compose`you don't have to use the IP address of our Eclipse Mosquitto sever, but you can simplay use `mosquitto` as the host nome.

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