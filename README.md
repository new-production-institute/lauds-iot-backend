# IoT Platform

## Docker

First install DockerDesktop and `docker-compose`:
* https://www.docker.com/products/docker-desktop/
* https://docs.docker.com/compose/install/

Then you can export a path to mount as a volume and spin up the containers:

```sh
export DATA_DIR = /some/path/to/mount
docker-compose --file software/container/docker-compose.yml up
```

### Grafana

You can login to Grafana: http://localhost:3000/login (admin:admin)

### NodeRed

NodeRed is running here: http://localhost:1880/

## Hardware

### Arduino IDE
We are using HelTec Automation Wirelsess Sticks ESP32 Dev-Boards. Their GitHub repo can be found here: https://github.com/HelTecAutomation/Heltec_ESP32

If you are using _Arduino IDE_ (just to try them out) you can add their Repo to the library managers URLs: https://github.com/HelTecAutomation/Heltec_ESP32/blob/master/library.json and/or find them in the IDE (Sketch -> Include Library -> Manage Libraries... Search for "heltec esp32").

### Find the port

```sh
esptool.py write_flash_status --non-volatile 0
```



