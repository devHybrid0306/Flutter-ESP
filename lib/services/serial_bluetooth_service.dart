import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

//This class is not used in out project as this for usual bluetooth devices and we aare using bluetooth low devices
class SerialBlueToothService {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice _device;

  bool _connected;

  SerialBlueToothService() {
    bluetoothInit();
  }

  Future<void> bluetoothInit() async {
    try {
      bluetooth.getBondedDevices().then((value) {
        devicesList = value;

        devicesList.forEach((value) {
          print(
              "Name: ${value.name} - Add ${value.address} - type ${value.type} - Connected ${value.connected}");
        });
      });

//      bluetooth.openSettings;

    } catch (e) {
      print(e);
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case FlutterBluetoothSerial.CONNECTED:
          _connected = true;
          break;

        case FlutterBluetoothSerial.DISCONNECTED:
          _connected = false;
          break;

        default:
          print(state);
          break;
      }
    });
  }

  connectToDevice(BluetoothDevice device) async {
    print('Connecting to ${device.name}');
    _device = device;

    bool result = await bluetooth.isAvailable;
    print('Available $result');

    bluetooth.connect(device).then((value) {
      print('Then $value');
    }).whenComplete(() {
      print('Connected');
    }).catchError((error) {
      print(error);
    }).then((value) {
      print('Connecting to $value');
    });
  }

  disconnectFromDevice() async {
    await bluetooth.disconnect();
  }

  bool get connected => _connected;

  set connected(bool value) {
    _connected = value;
  }

  BluetoothDevice get device => _device;

  set device(BluetoothDevice value) {
    _device = value;
  }

  List<BluetoothDevice> get devicesList => _devicesList;

  set devicesList(List<BluetoothDevice> value) {
    _devicesList = value;
  }
}
