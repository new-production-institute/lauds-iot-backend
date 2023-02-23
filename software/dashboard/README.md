# Grafana

Grafana is amn open source analytics and interactive visualization toll. It provides charts, graphs, and alerts for the web when connected to supported data sources. 

As a visualization tool, Grafana is a popular component in monitoring stacks, often used in combination with time series databases such as InfluxDB.

## Connection

To connect Grafana to our Influx-DB, you have to create a `token`in Influx-DB.
![Token](../flow/docs/images/influx-create-token.png)

You can use this token to create a connection from Grafana to Influx-DB.
![Connection](./docs/images/database-connection.png)

