# Node-RED

If you boot up our tech stack using `docker-compose` you already have a Node-RED instance running on[your local machine](http://localhost:1880/).

## first steps

For debuging shell into your Docker container and install the Node-RED Dashboard (we will switch to Grafana, soon):

```sh
npm install node-red-dashboard
```

Then the dashboard should be visible on the righmost menu item in Node-RED.

![Dashboard item](./docs/images/dashboard.png)

Then you can add a MQQT node to receive values from the power monitor, hook it up to a gauge and display it in a dasboard.

![Overview](./docs/images/1-overview.png)
![MQTT Node](./docs/images/2-mqtt-node.png) ![Gauge NOde](./docs/images/3-gauge-node.png) ![Dashboard Settings](./docs/images/4-dashboard-node.png)

The dashboard looks like that.

![Mobile view](./docs/images/5-dashboard.png)
