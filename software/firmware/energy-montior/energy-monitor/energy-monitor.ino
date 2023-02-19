/*
SCT-013 Sensor - Power meassurement, based on Thomas Edlinger's code for "www.edistechlab.com"
Required libraries (Tools -> manage libraries)
 - EmonLib libary V1.1.0 by OpenEnergyMonitor
Based on EmonLibrary examples openenergymonitor.org, Licence GNU GPL V3
*/

#include "EmonLib.h"
EnergyMonitor emon1;
const byte current1Pin = A1; // ADC-PIN
const byte voltage = 230;  // Power voltage in Europe = 230 V

void setup() {
  Serial.begin(115200);
  analogReadResolution(ADC_BITS); // activate 12 Bit resolution for our ESP32
  emon1.current(current1Pin, 8);  // Pin and Calibration
}

void loop() {
  double Irms = emon1.calcIrms(1480);
  Serial.print(Irms*voltage);
  Serial.print(" Watt  -  ");
  Serial.print(Irms);
  Serial.println(" Ampere");
  delay(1000);
}