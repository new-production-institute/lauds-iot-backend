# lauds-gateway-node-red-flows (case Fab City Hamburg | OpenLab Microfactory)

- development of Node-Red flows for the LAUDS Factory case-setting "Fab City Hamburg". 
- the flows include
  - data integration of machine and sensor APIs: 
    - PRUSA-LINK via Rest-API
    - Shelly Plug Energy Sensors via internal Mosquitto MQTT
    - Emon-Pi Energy Sensor Hub via MQTT, 
    - OpenLab Operating System for Small CNC and Big Laser via Websocket
  - data processing: energy per job
  - data forwarding: InfluxDB, external MQTT server

# Authors

- Hemanth Vudavagandla
- Michel Langhammer
