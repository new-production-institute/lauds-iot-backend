###  Node-RED Flow Documentation
- Shelly Data
    - ![](https://pad.fabcity.hamburg/uploads/595fa259-9f04-449e-9cb7-bcf418cdbfb8.png)
    - Flow Overview 
                This flow is designed to collect energy data from a Shelly device (SPPS-04), process it, and store it in an InfluxDB database. Additionally, a debug node is used to monitor the data at an intermediate step.
    - Nodes Description
        - SPPS-04 Shelly Data
            - Purpose: Receives real-time energy data from the SPPS-04 Shelly device.
            - Type: Mqtt in node (connect to the server and the topic by eidting the node)
                        ![](https://pad.fabcity.hamburg/uploads/03d72c22-9b80-4447-8d95-2fb7cd5c48c7.png)
                        ![](https://pad.fabcity.hamburg/uploads/8cfe5607-2b65-4f20-9a35-fd9e25b7fed7.png)
        - store current energy (Function Node)
            - Purpose: Processes incoming data to store the current energy reading in a desired format for further usage.
            - Type: Function Node
                ![](https://pad.fabcity.hamburg/uploads/0659faf3-b3a5-45d6-921d-28a613ab61ad.png)
        - structure for influx (Function Node)
            - Purpose: Structures incoming Shelly data into a format compatible with InfluxDB (e.g., measurement, fields, tags, timestamp).
            - Type: Function Node
                ![](https://pad.fabcity.hamburg/uploads/9835422c-d364-493a-9dc1-5613c7f34f9e.png)
        - InfluxDB-microfactory-pi (Influx Batch Node)
            - Purpose: Stores structured Shelly energy data into an InfluxDB instance for historical analysis and visualization.
            - Type: Influx Batch Node ( edit server, organization, bucket name and token with read and write access from the influxdb )
                ![](https://pad.fabcity.hamburg/uploads/c69b69f8-2140-4db0-be61-97eb28594d39.png)
                ![](https://pad.fabcity.hamburg/uploads/fbf86ef2-9e34-4733-b049-3db40a5cf1c6.png)
        - Debug Node 
            - Purpose: Displays messages from the "store current energy" node for troubleshooting or verification.
            - Type: Debug Node
            - Output: Debug pane in Node-RED UI.
- EmonPi Data
    ![](https://pad.fabcity.hamburg/uploads/792aeae2-a58d-4688-ba23-7a790c660dc0.png)
    - Flow Overview:
        The flow subscribes to energy data from EmonPi2 via MQTT, aggregates and extracts the required parameters, then structures the data for storage. It sends the processed readings into InfluxDB for historical tracking and visualization.
    - Nodes Description
        - emon/EmonPi2/# (MQTT In Node)
            - Purpose: Subscribes to the MQTT topic emon/EmonPi2/# to receive energy monitoring data from the EmonPi2 device.
            - Type: MQTT In Node (connect to the server and the topic by eidting the node)
            ![](https://pad.fabcity.hamburg/uploads/aa93960b-d4a5-4c6c-8a07-f386ad2e739f.png)
            ![](https://pad.fabcity.hamburg/uploads/5b8e3545-ec52-4f1b-9bfd-59546443d2e7.png)
        - Join Node
            - Purpose: Joins multiple incoming MQTT messages into a single message payload for easier processing downstream. This ensures that all required data points are available together.
            - Type: Join Node
            ![](https://pad.fabcity.hamburg/uploads/7e50c562-53eb-4144-a128-b4cd26273c6c.png)
        - Extract the required parameters (Function Node)
            - Purpose: Processes the joined MQTT payload and extracts only the necessary parameters (such as voltage, current, power, etc.) for further analysis.
            - Type: Function Node
            ![](https://pad.fabcity.hamburg/uploads/fb100853-cb5d-4e92-a2fa-4a30c7ca2026.png)
        - Structure for Influx (Function Node)
            - Purpose: Formats the extracted parameters into the structure required by InfluxDB, typically JSON with measurement, fields, and tags.
            - Type: Function Node
            ![](https://pad.fabcity.hamburg/uploads/b03e03e4-9042-4031-9c6c-0abe376293cd.png)
        - InfluxDB-microfactory-pi (Influx Batch Node)
            - Purpose: Purpose: Stores the processed and structured data into the InfluxDB instance for long-term storage and analysis.
            - Type: Influx Batch Node ( edit server, organization, bucket name and token with read and write access from the influxdb )
                ![](https://pad.fabcity.hamburg/uploads/c69b69f8-2140-4db0-be61-97eb28594d39.png)
                ![](https://pad.fabcity.hamburg/uploads/fbf86ef2-9e34-4733-b049-3db40a5cf1c6.png)
- Olsk - websocket
    ![](https://pad.fabcity.hamburg/uploads/cb8efb9d-97d0-456a-afa5-fe1b31c7f88b.png)
    - Flow Overview:
        The flow receives data from olsk-big-laser-v3 using websocket, limits it to 1 message per second, and extracts the required parameters.It structures the data into the proper format and stores it in InfluxDB
    - Nodes Description
        - olsk-big-laser-v3 (Websocket Node)
            - Purpose: Receives incoming data from the olsk-big-laser-v3 device for monitoring and processing.
            - Type: Websocket Node (edit the required properties)
            ![](https://pad.fabcity.hamburg/uploads/f813ec68-97af-466e-8514-60bf93e61b59.png)
        - limit ( Delay node)
            - Purpose: since the websocket is a stream of data we restrict the incoming data stream to 1 message per second, preventing overload and ensuring stable processing.
            - Type: Delay Node
            ![](https://pad.fabcity.hamburg/uploads/b02d2688-3f25-4005-8968-3a7092d083ad.png)
        - Extract the required parameters (Function Node)
            - Purpose: Extracts only the relevant parameters from the incoming payload for further processing (e.g., sensor readings).
            - Type: Function Node
            ![](https://pad.fabcity.hamburg/uploads/f0b7c0de-d5de-450b-b9ad-42805b79be26.png)
        - structure for influx (Function Node)
            - Purpose: Formats the extracted parameters into the JSON structure required for InfluxDB storage.
            - Type: Function Node
            ![](https://pad.fabcity.hamburg/uploads/7d6d715f-17d4-4357-b102-e0ed9d2aa61c.png)
        - influxDB (Influx Batch Node)
            - Purpose: Stores the structured data into the InfluxDB microfactory database for long-term analysis and visualization.
            - Type: Influx Batch Node
            ![](https://pad.fabcity.hamburg/uploads/8ec85ac4-386c-40bb-984f-afaba001d61a.png)
            ![](https://pad.fabcity.hamburg/uploads/57714629-7455-4a16-b214-42ead8fe3e17.png)