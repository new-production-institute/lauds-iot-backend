# IoT Platform

## Docker

First install DockerDesktop and `docker-compose`:

- https://www.docker.com/products/docker-desktop/
- https://docs.docker.com/compose/install/

Then you can export a path to mount as a volume and spin up the containers:

```sh
export DATA_DIR = /some/path/to/mount
docker-compose --file software/container/docker-compose.yml up
```

### Mosquitto

```sh
mosquitto_sub -h localhost -t '#' -p 1883
mosquitto_pub -h localhost -p 1883 -t '/' -m $(date --utc +%s)
```

### Grafana

You can login to Grafana: http://localhost:3000/login (admin:admin)

### Node-RED

NodeRed is running here: http://localhost:1880/

> A simple introduction to Node-RED can be found - along with the nodes -  in [this repository](./software/flow/README.md). 

## Hardware

We are using HelTec Automation Wirelsess Sticks ESP32 Dev-Boards.

### PinOut

The PinOut of our version 3 modules can be found here:  https://docs.heltec.org/en/node/esp32/dev-board/hardware_update_log.html#wifi-lora-32-hardware-update-logs

![PinOut](https://resource.heltec.cn/download/Wireless_Stick_V3/HTIT-WS_V3.png "PinOut")

### License

For some parts of the Heltec board you need a ["license"](https://docs.heltec.org/general/view_limited_technical_data.html#esp32-lora-series).

### USB-C
Our HelTec Automation Wirelsess Sticks ESP32 Dev-Boards already have USB-C. But they do not support Power Deliver (PD). If your computer tries to do PD, just plug a cheap USB hub between the board and your computer.

### Arduino IDE

HelTecs GitHub repo can be found here: https://github.com/HelTecAutomation/Heltec_ESP32

I had to install VCP Drivers, first: https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers?tab=downloads

You can add their Board Manager to the boards managers URLs: https://github.com/HelTecAutomation/Heltec_ESP32/blob/master/library.json and find their libraries in the IDE (Sketch -> Include Library -> Manage Libraries... Search for "heltec esp32").

> These boards are already *V3* boards, so be careful selecting the right board and port (VCP).

![Arduino IDE](docs/images/flash-with-arduino.png "select the right board and port")

### Install esptool

Esptool is a Pyhton program to flash ESP32. As it's a Pyhton tool you can install it using `pip`:

```sh
pip install esptool
```

### Find the port 

Usually you can find the used port using `esptool.py`:

```sh
esptool.py write_flash_status --non-volatile 0
```

#### Using MicroPython

Download the firmware: https://micropython.org/download/

Flash it using `esptool`: https://micropython.org/download/GENERIC_S3/


```sh
esptool.py --chip esp32s3  write_flash -z 0  ~/Desktop/GENERIC_S3-20220117-v1.18.bin
```

## Hardware sensors

* [Energy Monitor](./software/firmware/energy-monitor/README.md)
* [Shelly Example](./software/firmware/shelly-monitor/README.md)

## Tutorials

* A great tutorial can be found at [microcontrollerlab.com](https://microcontrollerslab.com/esp32-mqtt-publish-multiple-sensor-readings-node-red/)
