#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
int blinkSeconds = 0;
bool newLedState = false; //false for LOW and true for HIGH
bool prevLedState = false;

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

const int LED = 2;

// handle for blinking led
TaskHandle_t blinkerHandle = NULL;
// handle for led state
TaskHandle_t ledStateHandle = NULL;

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      BLEDevice::startAdvertising();
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

void blinkLED(void* p) {
  Serial.println("Seconds ");
  Serial.println(blinkSeconds);
  while (true) {
    Serial.println("off");
    digitalWrite(LED, LOW);
    Serial.println("Delay 300");
    vTaskDelay(400 / portTICK_PERIOD_MS);
    Serial.println("on");
    digitalWrite(LED, HIGH);
    Serial.println("delay " + String(blinkSeconds * 1000));
    vTaskDelay((blinkSeconds * 1000) / portTICK_PERIOD_MS);
  }
}

void switchLEDTask(void *v) {
  while (true) {

    if (prevLedState == newLedState) {
      continue;
    }
    prevLedState = newLedState;
    Serial.println("LED STATE " + String(newLedState));
    int value = newLedState ? HIGH : LOW;
    digitalWrite(LED, value);
  }
}


class Callback : public BLECharacteristicCallbacks {

    void onWrite(BLECharacteristic *v) {
      std::string value = v->getValue();
      if (value.length() > 0) {
        deleteTask();
        Serial.println("===================");
        Serial.print("New Value: ");
        String result = "";
        for (int i = 0; i < value.length(); i++) {
          Serial.print(value[i]);
          result += value[i];
        }
        Serial.println();
        Serial.println("===================");
        if (result.startsWith("timeout")) {
          Serial.println("StartsWith Timeout function=====");
          Serial.println("Result " + String(result));
          blinkSeconds = result.substring(result.indexOf("=") + 1).toInt();
          xTaskCreatePinnedToCore( blinkLED, "blinker", 10000, NULL, 1, &blinkerHandle, 0);
        }
        else if (result.equals("1")) {
          newLedState = true;
          xTaskCreatePinnedToCore( switchLEDTask, "led state on", 10000, NULL, 1, &ledStateHandle, 1);
        } else if (result.equals("0")) {
          newLedState = false;
          xTaskCreatePinnedToCore( switchLEDTask, "led State off", 10000, NULL, 1, &ledStateHandle, 1);
        }
      }
    }

};

void deleteTask() {
  if (blinkerHandle != NULL) {
    Serial.println("Another Task Running killing previos task");
    vTaskDelete(blinkerHandle);
  } if (ledStateHandle != NULL) {
    Serial.println("Killing LED Task");
    vTaskDelete(ledStateHandle);
  }
}

void setup() {
  Serial.begin(115200);

  pinMode(LED, OUTPUT);
  // Create the BLE Device
  BLEDevice::init("ESP32");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());
  pCharacteristic->setCallbacks(new Callback());
  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}

void loop() {

}