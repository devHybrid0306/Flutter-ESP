import 'package:esp_connect/services/ble_bluetooth_service.dart';
import 'package:esp_connect/services/esp_service.dart';
import 'package:esp_connect/services/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';

class HomeState extends ChangeNotifier {


  var _espService = locator<EspService>();
  var _bluetoothService = locator<BleBluetoothService>();

  HomeState() {

  }

  bool _switchState = false;

  bool get switchState => _switchState;

  set switchState(bool value) {
    _switchState = value;
  }

  void sentDataToESP(bool val) {
    _espService.sendData(_bluetoothService.device, val);
  }

  void sendTextToESP(String value) {
    _espService.sendText(_bluetoothService.device, value);
  }

  getConnectedDeviceName() {
    return _bluetoothService.device == null
        ? "Connect to device "
        : _bluetoothService.device.name;
  }
}
