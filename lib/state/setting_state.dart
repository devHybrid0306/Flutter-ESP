import 'package:esp_connect/services/local_storage_service.dart';
import 'package:esp_connect/services/serial_bluetooth_service.dart';
import 'package:esp_connect/services/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class SettingState extends ChangeNotifier {
  var localStorage = locator<LocalStorageService>();

  
  int _switchOnCode=0;
  int _switchOffCode=1;

  List<BluetoothDevice> _devices = List();

  SettingState() {
    _switchOnCode = localStorage.switchOnCode;
    _switchOffCode = localStorage.switchOffCode;
  }

  int get switchOnCode => _switchOnCode;

  int get switchOffCode => _switchOffCode;

  setSwitchOnCode(int code) {
    _switchOnCode = code;
    localStorage.switchOnCode = code;
  }

  setSwitchOffCode(int code) {
    _switchOffCode = code;
    localStorage.switchOffCode = code;
  }

  connectToDevice(BluetoothDevice device)  {
//     bluetoothSerial.connectToDevice(device);
  }

  List<BluetoothDevice> get devices => _devices;
}
