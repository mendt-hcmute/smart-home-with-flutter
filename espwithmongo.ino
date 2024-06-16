/*
  Title: Control your Arduino IoT projects with a MongoDB database
  Author: donsky (www.donskytech.com)
*/
#include <Arduino.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include "DHT.h"
//#include <Wifi.h>
#include <LCD_I2C.h>


// SSID and Password
const char *ssid = "TP-LINK1Gb";
const char *password = "12345678";

/**** NEED TO CHANGE THIS ACCORDING TO YOUR SETUP *****/
// The REST API endpoint - Change the IP Address
const char *base_rest_url = "http://192.168.0.104:5000/";

WiFiClient client;
HTTPClient http;

// Read interval
unsigned long previousMillis = 0;
const long readInterval = 5000;
// LED Pin

const int AIR_CONDITION = 25;
const int FAN = 32;
//Khai bao den test
const int den_test_CBAS = 2;
const int den_test_CB_CD = 5;
struct LED
{
  char sensor_id[10];
  char status[10];
};


// DHT Object ID
char dhtObjectId[30];
#define DHTPIN 16 // Digital pin connected to the DHT sensor
#define DHTTYPE DHT22 // DHT 22  (AM2302), AM2321
DHT dht(DHTPIN, DHTTYPE);
struct DHT22Readings
{
  float temperature;
  float humidity;
};


// mq2 Object ID & data
char mq2ObjectId[30];
float readingGas;

// lightSensor Object ID & data;
char lightSensorObjectID[30];
float readingLight;

const int camBien_CD = 15;
const int buzzer = 4;

LCD_I2C lcd(0x27, 16, 2);




// Size of the JSON document. Use the ArduinoJSON JSONAssistant
const int JSON_DOC_SIZE = 384;
// HTTP GET Call
StaticJsonDocument<JSON_DOC_SIZE> callHTTPGet(const char *sensor_id)
{
  char rest_api_url[200];
  // Calling our API server
  sprintf(rest_api_url, "%sapi/sensor?sensor_id=%s", base_rest_url, sensor_id);
  Serial.println(rest_api_url);

  http.useHTTP10(true);
  http.begin(client, rest_api_url);
  http.addHeader("Content-Type", "application/json");
  http.GET();

  StaticJsonDocument<JSON_DOC_SIZE> doc;
  // Parse response
  DeserializationError error = deserializeJson(doc, http.getStream());

  if (error)
  {
    Serial.print("deserializeJson() failed: ");
    Serial.println(error.c_str());
    return doc;
  }

  http.end();
  return doc;
}
// Extract LED records
LED extractLEDConfiguration(const char *sensor_id)
{
  StaticJsonDocument<JSON_DOC_SIZE> doc = callHTTPGet(sensor_id);
  if (doc.isNull() || doc.size() > 1)
    return {}; // or LED{}
  for (JsonObject item : doc.as<JsonArray>())
  {

    const char *sensorId = item["sensor_id"];      // "led_1"
    const char *status = item["status"];           // "HIGH"

    LED ledTemp = {};
    strcpy(ledTemp.sensor_id, sensorId);
    strcpy(ledTemp.status, status);

    return ledTemp;
  }
  return {}; // or LED{}
}

// Send DHT22 readings using HTTP PUT
void sendDHT22Readings(const char *objectId, DHT22Readings dhtReadings)
{
  char rest_api_url[200];
  // Calling our API server
  sprintf(rest_api_url, "%sapi/sensor/%s", base_rest_url, objectId);
  Serial.println(rest_api_url);

  // Prepare our JSON data
  String jsondata = "";
  StaticJsonDocument<JSON_DOC_SIZE> doc;
  JsonObject readings = doc.createNestedObject("readings");
  readings["temperature"] = dhtReadings.temperature;
  readings["humidity"] = dhtReadings.humidity;

  serializeJson(doc, jsondata);
  Serial.println("JSON Data...");
  Serial.println(jsondata);

  http.begin(client, rest_api_url);
  http.addHeader("Content-Type", "application/json");

  // Send the PUT request
  int httpResponseCode = http.PUT(jsondata);
  if (httpResponseCode > 0)
  {
    String response = http.getString();
    Serial.println(httpResponseCode);
    Serial.println(response);
  }
  else
  {
    Serial.print("Error on sending POST: ");
    Serial.println(httpResponseCode);
    http.end();
  }
}

// Get DHT22 ObjectId
void getDHT22ObjectId(const char *sensor_id)
{
  StaticJsonDocument<JSON_DOC_SIZE> doc = callHTTPGet(sensor_id);
  if (doc.isNull() || doc.size() > 1)
    return;
  for (JsonObject item : doc.as<JsonArray>())
  {
    Serial.println(item);
    const char *objectId = item["_id"]["$oid"]; // "dht22_1"
    strcpy(dhtObjectId, objectId);

    return;
  }
  return;
}

// Read DHT22 sensor
DHT22Readings readDHT22()
{
  // Reading temperature or humidity takes about 250 milliseconds!
  // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
  float humidity = dht.readHumidity();
  // Read temperature as Celsius (the default)
  float temperatureInC = dht.readTemperature();
  // // Read temperature as Fahrenheit (isFahrenheit = true)
  // float temperatureInF = dht.readTemperature(true);

  return {temperatureInC, humidity};
}
// Convert HIGH and LOW to Arduino compatible values
int convertStatus(const char *value)
{
  if (strcmp(value, "HIGH") == 0)
  {
    Serial.println("Setting LED to HIGH");
    return HIGH;
  }
  else
  {
    Serial.println("Setting LED to LOW");
    return LOW;
  }
}
// Set our LED status
void setLEDStatus(int pin, int status)
{
  Serial.printf("Setting LED status to : %d", status);
  Serial.println("");
  digitalWrite(pin, status);
}

// Get Gas ObjectId
void getGasObjectId(const char *sensor_id)
{
  StaticJsonDocument<JSON_DOC_SIZE> doc = callHTTPGet(sensor_id);
  if (doc.isNull() || doc.size() > 1)
    return;
  for (JsonObject item : doc.as<JsonArray>())
  {
    Serial.println(item);
    const char *objectId = item["_id"]["$oid"]; // ObjectId of the gas document in MongoDB
    strcpy(mq2ObjectId, objectId);

    return;
  }
  return;
}

// Send Gas readings using HTTP PUT
void sendGasReadings(const char *objectId, int gasReading)
{
  char rest_api_url[200];
  // Calling our API server
  sprintf(rest_api_url, "%sapi/sensor/%s", base_rest_url, objectId);
  Serial.println(rest_api_url);

  // Prepare our JSON data
  String jsondata = "";
  StaticJsonDocument<JSON_DOC_SIZE> doc;
  doc["readingGas"] = gasReading;

  serializeJson(doc, jsondata);
  Serial.println("JSON Data for Gas...");
  Serial.println(jsondata);

  http.begin(client, rest_api_url);
  http.addHeader("Content-Type", "application/json");

  // Send the PUT request
  int httpResponseCode = http.PUT(jsondata);
  if (httpResponseCode > 0)
  {
    String response = http.getString();
    Serial.println(httpResponseCode);
    Serial.println(response);
  }
  else
  {
    Serial.print("Error on sending POST: ");
    Serial.println(httpResponseCode);
    http.end();
  }
}


void getLightSensorObjectId(const char *sensor_id)
{
  StaticJsonDocument<JSON_DOC_SIZE> doc = callHTTPGet(sensor_id);
  if (doc.isNull() || doc.size() > 1)
    return;
  for (JsonObject item : doc.as<JsonArray>())
  {
    Serial.println(item);
    const char *objectId = item["_id"]["$oid"]; // ObjectId of the gas document in MongoDB
    strcpy(lightSensorObjectID, objectId);

    return;
  }
  return;
}

// Send light sensor readings using HTTP PUT
void sendLightSensorReadings(const char *objectId, int lightSensorReading)
{
  char rest_api_url[200];
  // Calling our API server
  sprintf(rest_api_url, "%sapi/sensor/%s", base_rest_url, objectId);
  Serial.println(rest_api_url);

  // Prepare our JSON data
  String jsondata = "";
  StaticJsonDocument<JSON_DOC_SIZE> doc;
  doc["readingLight"] = lightSensorReading;

  serializeJson(doc, jsondata);
  Serial.println("JSON Data for Gas...");
  Serial.println(jsondata);

  http.begin(client, rest_api_url);
  http.addHeader("Content-Type", "application/json");

  // Send the PUT request
  int httpResponseCode = http.PUT(jsondata);
  if (httpResponseCode > 0)
  {
    String response = http.getString();
    Serial.println(httpResponseCode);
    Serial.println(response);
  }
  else
  {
    Serial.print("Error on sending POST: ");
    Serial.println(httpResponseCode);
    http.end();
  }
}


void setup()
{

  // initialize lcd
  lcd.begin();
  // turn on lcd backlight                      
  lcd.backlight();

  Serial.begin(115200);
  for (uint8_t t = 2; t > 0; t--)
  {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(1000);
  }

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  //  Start DHT Sensor readings
  dht.begin();
  //  Get the ObjectId of the DHT22 sensor
  getDHT22ObjectId("dht22_1");
  // Setup LED
  pinMode(AIR_CONDITION, OUTPUT);
  pinMode(den_test_CBAS, OUTPUT);
  pinMode(den_test_CB_CD, OUTPUT);
  pinMode(FAN, OUTPUT);
  pinMode(buzzer, OUTPUT);

  // digitalWrite(AIR_CONDITION, LOW);
  // digitalWrite(den_test_CBAS, LOW);
  // digitalWrite(den_test_CB_CD, LOW);
  // digitalWrite(FAN, LOW);


  getGasObjectId("mq2");

  getLightSensorObjectId("light_sensor");

  pinMode(camBien_CD, INPUT);

}

void loop()
{
  //value from mq-2
  int val_gas = analogRead(35);
  int percentage = map(val_gas, 0, 4095, 0, 100);

  //value from light sensor
  int giatriCBAS = analogRead(33);
  int percentAS = map(giatriCBAS,0, 4095, 0, 100);

  unsigned long currentMillis = millis();

  int giatriCBCD = digitalRead(camBien_CD);

  if (giatriCBCD == 1) {
    Serial.println("Co nguoi");
    digitalWrite(den_test_CB_CD, HIGH);
    delay(200);
  } else {
    digitalWrite(den_test_CB_CD, LOW);
  }

  if (currentMillis - previousMillis >= readInterval)
  {
    // save the last time
    previousMillis = currentMillis;

    Serial.println("---------------");
    // Read our configuration for our LED
    LED fanSetup = extractLEDConfiguration("fan");
    Serial.println(fanSetup.sensor_id);
    Serial.println(fanSetup.status);
    setLEDStatus(FAN,convertStatus(fanSetup.status)); // Set fan value

    LED air_conditionSetup = extractLEDConfiguration("air_condition");
    Serial.println(air_conditionSetup.sensor_id);
    Serial.println(air_conditionSetup.status);
    setLEDStatus(AIR_CONDITION,convertStatus(air_conditionSetup.status)); // Set air_condition value

    LED light1Setup = extractLEDConfiguration("light1");
    Serial.println(light1Setup.sensor_id);
    Serial.println(light1Setup.status);
    //setLEDStatus(,convertStatus(light1Setup.status)); // Set light1 value

    LED light2Setup = extractLEDConfiguration("light2");
    Serial.println(light2Setup.sensor_id);
    Serial.println(light2Setup.status);
    //setLEDStatus(,convertStatus(light2Setup.status)); // Set light2 value

    Serial.println("---------------");
    // Send our DHT22 sensor readings
    // Locate the ObjectId of our DHT22 document in MongoDB
    Serial.println("Sending latest DHT22 readings");
    DHT22Readings readings = readDHT22();
    // Check if any reads failed and exit early (to try again).
    if (isnan(readings.humidity) || isnan(readings.temperature))
    {
      Serial.println(F("Failed to read from DHT sensor!"));
      return;
    }

    Serial.print("Temperature :: ");
    Serial.println(readings.temperature);
    Serial.print("Humidity :: ");
    Serial.println(readings.humidity);
    sendDHT22Readings(dhtObjectId, readings);

    Serial.print("Gas: ");
    Serial.println(percentage);

    sendGasReadings(mq2ObjectId, percentage);
    Serial.println("---------------");
    Serial.print("Gia tri CBAS: ");
    Serial.println(giatriCBAS);
    Serial.print("% ");
    Serial.println(percentAS);

    if (percentage > 80){
      digitalWrite(buzzer, HIGH);

    }
    else{
      digitalWrite(buzzer,LOW);
    }


    if (percentAS >= 80){
      digitalWrite(den_test_CBAS, HIGH);
    }
    else{
      digitalWrite(den_test_CBAS,LOW);
    }

    sendLightSensorReadings(lightSensorObjectID, percentAS); 

    //LCD
  lcd.clear();
  lcd.setCursor(0, 1);
  lcd.print("Gas:");
  lcd.print(percentage);
  lcd.print("%");

  lcd.setCursor(0, 0);
  lcd.print("Temp:");
  lcd.print(readings.temperature);
  lcd.setCursor(8, 1);
  lcd.print("Hum:");
  lcd.print(readings.humidity);

  }
}