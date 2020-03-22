import 'package:esp_connect/BluetoothDeviceList.dart';
import 'package:esp_connect/state/setting_state.dart';
import 'package:esp_connect/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController switchOnTextController = TextEditingController();

  TextEditingController switchOffTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<SettingState>(context);
    switchOnTextController.text = state.switchOnCode.toString();
    switchOffTextController.text = state.switchOffCode.toString();
    return WillPopScope(
      child: Scaffold(
//        backgroundColor: Constants.dayColor,
        appBar: AppBar(
          backgroundColor: Constants.nightColor,
        ),
        body: SafeArea(
          child: CustomScrollView(
//            shrinkWrap: true,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          child: Text(
                            "Codes",
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        ),
                        ListTile(
                          dense: true,
                          leading: Text(
                            "On Code ",
                          ),
                          trailing: SizedBox(
                            width: 50,
                            child: TextField(
                              controller: switchOnTextController,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              style: TextStyle(),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                state.setSwitchOnCode(int.parse(value));
                              },
                            ),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          leading: Text(
                            "Off Code ",
                          ),
                          trailing: SizedBox(
                            width: 50,
                            child: TextField(
                              controller: switchOffTextController,
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              style: TextStyle(),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                state.setSwitchOffCode(int.parse(value));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BluetoothDeviceList(
                    Padding(
                      child: Text(
                        "Paired Devices",
                        style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        return true;
      },
    );
  }
}
