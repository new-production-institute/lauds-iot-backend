# Shelly Plug (S)

Shelly Plugs S are quite cheap but relatively accurate to measure power consumptions less than 2.5 kW.

In our [smart-energy-montior](https://code.curious.bio/curious.bio/smart-energy-monitor) project we already have set up a Shelly using Tasmota, on Open Source alternative firmware, that also runs on various other consumer off the shelf devices.


## InfluxDB Bucket

In Influx I created a bucket called `shelly`in InfluxDB, so we can store the messages in this bucket.

### Node-RED

I create a usual flow in Node-RED. A MQTT node fetches the values. 

![Node-RED](./docs/images/node-red.png)

The message is fed into a filter function to only store usefull information:

```
return  {
    payload: {
        power: Number(msg.payload.ENERGY.Power),
        voltage: Number(msg.payload.ENERGY.Voltage),
        current: Number(msg.payload.ENERGY.Current)
    }
};
````

The `payload` will be stored in InfluxDB in the bucket "shelly".

### InfluxDB Data Explorer

In Influx DB Data Explorer you can query the stored data.

![Data Explorer](./docs/images/data-explorer.png)

The query created by Data Explorer looks like that:

```
from(bucket: "shelly")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "msg")
  |> filter(fn: (r) => r["_field"] == "power" or r["_field"] == "voltage" or r["_field"] == "current")
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)
  |> yield(name: "mean")
```

### Grafana

Using this query you can crate a dashboard in Grafana.

![Grafana](./docs/images/grafana.png)
