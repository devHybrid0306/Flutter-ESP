import 'package:esp_connect/services/ble_bluetooth_service.dart';
import 'package:esp_connect/services/esp_service.dart';
import 'package:esp_connect/services/serial_bluetooth_service.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get_it/get_it.dart';

import 'local_storage_service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<BleBluetoothService>(BleBluetoothService());
//  locator.registerSingleton<SerialBlueToothService>(SerialBlueToothService());
  var instance = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(instance);

  locator.registerSingleton<EspService>(EspService());
}
