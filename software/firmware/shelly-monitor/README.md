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

After a while your Shelly Plug S should be flashed with Tasmota firmware and create a new Wifi. Join that Wifi and [configure the device)(http://192.164.4.1/).

> Note: This bricked my shelly device. I cannot reach it, anymore.

It should be configurable just like our [plant monitor](../plant-monitor/README.md).
