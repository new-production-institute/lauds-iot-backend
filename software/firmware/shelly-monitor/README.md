# Shelly Plug

Shelly Plugs are quite cheap but relatively accurate to measure power consumptions less than 2.5 kW.

## Using Shellies Firmware

If you already have a sheyll device, you can locate it in your network.

![Web interface](./docs/images/shelly1.png "web interace")

MQTT can be enabled under "ADVANCED - DEVELOPER SETTINGS" -> "MQTT".

![MQTT](./docs/images/shelly2.png "mqtt2")

Then it will post a message on boot to your MQTT server:
```json
{
  "wifi_sta": {
    "connected": true,
    "ssid": "Guest",
    "ip": "192.168.2.150",
    "rssi": -43
  },
  "cloud": {
    "enabled": false,
    "connected": false
  },
  "mqtt": {
    "connected": true
  },
  "time": "17:19",
  "unixtime": 1676909964,
  "serial": 1,
  "has_update": false,
  "mac": "4022D8891E97",
  "cfg_changed_cnt": 0,
  "actions_stats": {
    "skipped": 0
  },
  "relays": [
    {
      "ison": true,
      "has_timer": false,
      "timer_started": 0,
      "timer_duration": 0,
      "timer_remaining": 0,
      "overpower": false,
      "source": "input"
    }
  ],
  "meters": [
    {
      "power": 117.46,
      "overpower": 0,
      "is_valid": true,
      "timestamp": 1676913564,
      "counters": [
        0,
        0,
        0
      ],
      "total": 0
    }
  ],
  "temperature": 0,
  "overtemperature": false,
  "tmp": {
    "tC": 0,
    "tF": 32,
    "is_valid": true
  },
  "update": {
    "status": "unknown",
    "has_update": false,
    "new_version": "",
    "old_version": "20230109-114426/v1.12.2-g32055ee"
  },
  "ram_total": 52064,
  "ram_free": 39744,
  "fs_size": 233681,
  "fs_free": 166664,
  "uptime": 5
}
```

You an use shelly script to update this status periodically.

A documentation on how to do this can be found on [Shellie's documentation](https://shelly-api-docs.shelly.cloud/gen2/ComponentsAndServices/Mqtt/).

## Flash Tasmota

There's an OpenSource project to flash Tasmota on Shelly Plug S':  [mg2x](https://github.com/arendst/mgos-to-tasmota)

> Danger: This is still not working.

Locate your Shellie's IP adress (here: 192.168.2.150) and update it "over the air" with the Tasmota firmware:

http://192.168.2.150/ota?url=http://ota.tasmota.com/tasmota/shelly/mg2tasmota-ShellyPlugS.zip

Your shelly will return something like a JSON object that looks like that:

```
{
  "status": "updating",
  "has_update": false,
  "new_version": "20230109-114426/v1.12.2-g32055ee",
  "old_version": "20230109-114426/v1.12.2-g32055ee"
}
```

After a while your Shelly Plug S should be flashed with Tasmota firmware.

> Just be patient. This took longer than five minutes in my DSL connected network. 

It will create create a new Wifi. 

![Tasmota Wifi](./docs/images/wifi.png)

Join that Wifi and [configure the device)(http://192.164.4.1/).

![Join Wifi](./docs/images/configure-wifi.png)

You can configure it a a BlitzWolf SHP product. 

Then it offers you power measurement and a programmable toogle.

![BlitzWolf](./docs/images/blitzwolf.png)

It should be configurable just like our [plant monitor](../plant-monitor/README.md).

Just enable MQTT and enter a shorter telemetry period.

![MQTT](./docs/images/mqtt.png) ![Telemetry period](./docs/images/telemetry-period.png)

It will post MQTT messages unter a topic `tele/tasmota_891E97/SENSOR` like this one:

```
{
  "Time": "2023-02-27T16:45:07",
  "ENERGY": {
    "TotalStartTime": "2023-02-27T16:33:06",
    "Total": 0.004,
    "Yesterday": 0,
    "Today": 0.004,
    "Period": 0,
    "Power": 34,
    "ApparentPower": 44,
    "ReactivePower": 27,
    "Factor": 0.79,
    "Voltage": 253,
    "Current": 0.172
  }
}
```

We now can consume this messages in Node-RED and post them into InfluxDB and build a dashboard in Grafana.

### InfluxDB Bucket

I created a bucket called `Shelly`in InfluxDB, so we can store the messages in this bucket.

### Node-RED

I create a usual flow in Node-RED. A MQTT node fetches the values. 

![Node-RED](./docs/images/node-red.png)

The message is fed into a filter function to filter usefull information:

```
return  {
    payload: {
        power: Number(msg.payload.ENERGY.Power),
        volate: Number(msg.payload.ENERGY.Voltage),
        current: Number(msg.payload.ENERGY.Current)
    }
};
````

The `payload` will be stored in InfluxDB in the bucket "shelly".

### InfluxDB Data Explorer

In Influx DB Data Explorer you can query the stored data.

![Data Explorer](./docs/images/data-explorer.png)

The query created by Data Explorer look like that:

```
from(bucket: "shelly")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "msg")
  |> filter(fn: (r) => r["_field"] == "power" or r["_field"] == "volate" or r["_field"] == "current")
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)
  |> yield(name: "mean")
```

### Grafana

Using this query you can crate a dashboard in Grafana.

![Grafana](./docs/images/grafana.png)