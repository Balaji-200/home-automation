#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>

// Set these to run example.

#define FIREBASE_HOST "YOUR FIREBASE HOST"

#define FIREBASE_AUTH "YOUR FIREBASE AUTH"

#define WIFI_SSID "YOUR WIFI SSID"

#define WIFI_PASSWORD "YOUR WIFI PASSWORD"

#define LED1 D5
#define LED2 D2

#define DIMMER D1

FirebaseData led1, led2, dim;

void setup() {

pinMode(LED1,OUTPUT);
pinMode(LED2,OUTPUT);
pinMode(DIMMER,OUTPUT);

Serial.begin(115200);

WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

Serial.print("connecting");

while (WiFi.status() != WL_CONNECTED) {

Serial.print(".");

delay(500);

}

Serial.println();

Serial.print("connected: ");

Serial.println(WiFi.localIP());

Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
Firebase.reconnectWiFi(true);

}

void loop() {
Firebase.RTDB.getInt(&led1, "led1");
if(led1.dataType() == "int")
{
  digitalWrite(LED1, led1.intData());
}

Firebase.RTDB.getInt(&led2, "led2");
if(led2.dataType() == "int")
{
  digitalWrite(LED2, led2.intData());
}

Firebase.RTDB.getInt(&dim, "slider");
if(dim.dataType() == "int")
{
  analogWrite(DIMMER, dim.intData());
}
delay(100);
}
