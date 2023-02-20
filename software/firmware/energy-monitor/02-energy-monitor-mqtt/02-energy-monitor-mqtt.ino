/*
Required libraries (Tools -> manage libraries)
 - EmonLib@1.1.0
 - PubSubClient@2.8.0
 - Wifi
*/
#include <stdlib.h>
#include <string.h>
#include "EmonLib.h"
#include <WiFi.h>
#include <PubSubClient.h>
#include "environment.h" // put your credentials and configuration in, here

// sensor
EnergyMonitor emon1;
const byte current1Pin = A1; // ADC-PIN
const byte voltage = 230;  // Power voltage in Europe = 230 V

// refrences from environment.h
const char* ssid = secrect_ssid;
const char* password = secret_password;
const char* mqttServer = mqtt_server;
const int mqttPort = mqtt_port;
const char* mqttPrefix = mqtt_prefix;

// wifi and MQTT
WiFiClient wifiClient;
PubSubClient client(wifiClient);


void setup() {
  Serial.begin(115200);
  Serial.setTimeout(500);
  setup_energy_sensor();
  setup_wifi();
  setup_mqtt();
}

void setup_energy_sensor() {
  analogReadResolution(ADC_BITS); // activate 12 Bit resolution for our ESP32
  emon1.current(current1Pin, 8);  // Pin and Calibration
}

void setup_wifi() {
    delay(10);
    Serial.println();
    Serial.print("Connecting to ");
    Serial.println(ssid);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }
    randomSeed(micros());
    Serial.println("");
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
}

void setup_mqtt() {
  client.setServer(mqttServer, mqttPort);
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Create a random client ID
    String clientId = "ESP32Client-";
    clientId += String(random(0xffff), HEX);
    // Attempt to connect
    if (client.connect(clientId.c_str())) {
      Serial.println("connected");
      //Once connected, publish an announcement...
      client.publish(concat(mqttPrefix, "/status"), "online");
      // ... and resubscribe
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}


char* concat(const char* str1, const char* str2) {
    char* result;
    asprintf(&result, "%s%s", str1, str2);
    return result;
}

void loop() {
  // get values
  double irms = emon1.calcIrms(1480);
  double power = irms * voltage;

  // debug, print out on serial
  Serial.print(power);
  Serial.print(" Watt  -  ");
  Serial.print(irms);
  Serial.println(" Ampere");

  // convert double to char array for MQTT
  char powerArray[10];
  snprintf(powerArray, 10, "%f", power);
  char irmsArray[10];
  snprintf(irmsArray, 10, "%f", irms);


  // publish values
  client.publish(concat(mqttPrefix, "/watt"), powerArray);
  client.publish(concat(mqttPrefix, "/ampere"), irmsArray);
 
  // wait a second
  delay(1000);
}