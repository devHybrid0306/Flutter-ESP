import 'dart:async';

import 'package:day_night_switch/day_night_switch.dart';

import 'package:esp_connect/screen/setting_screen.dart';
import 'package:esp_connect/services/service_locator.dart';
import 'package:esp_connect/state/home_screen_state.dart';
import 'package:esp_connect/state/setting_state.dart';
import 'package:esp_connect/utility/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController messageController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<HomeState>(context);

    var val = state.switchState;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF414a4c),
      body: AnimatedContainer(
        color: val ? Constants.nightColor : Constants.dayColor,
        duration: Duration(milliseconds: 300),
        child: Stack(
          children: <Widget>[
            buildStar(top: 100, left: 40, val: val),
            buildStar(top: 200, left: 80, val: val),
            buildStar(top: 300, left: 10, val: val),
            buildStar(top: 500, left: 100, val: val),
            buildStar(top: 300, right: 40, val: val),
            buildStar(top: 250, right: 100, val: val),
            buildStar(top: 450, right: 80, val: val),
            Positioned(
              bottom: 0,
              right: 0,
              height: 200,
              child: Image.asset(
                val ? 'assets/mountain2_night.png' : 'assets/mountain2.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: -10,
              left: 0,
              right: 0,
              height: 140,
              child: Image.asset(
                val ? 'assets/mountain_night.png' : 'assets/mountain1.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DayNightSwitch(
                    value: val,
                    moonImage: AssetImage('assets/moon.png'),
                    onChanged: (value) {
                      setState(() {
                        state.switchState = value;
                        sendData(val, state);
                      });
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.all(26),
                      child: TextField(
                        onChanged:(value){
                          state.sendTextToESP(value);
                        },
                        onSubmitted: (value)  {
                          state.sendTextToESP(value);
                        },
                        textInputAction: TextInputAction.done,
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
            Positioned(
              top: 30,
              child: FlatButton.icon(
                  padding: EdgeInsets.all(14),
                  onPressed: () {
                    showSettingsPage();
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  label: Text(
                    state.getConnectedDeviceName(),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  buildStar({double top, double left, double right, bool val}) {
    return Positioned(
      top: top,
      right: right,
      left: left,
      child: Opacity(
        opacity: val ? 1 : 0,
        child: CircleAvatar(
          radius: 2,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  void sendData(bool val, HomeState state) async {
    state.sentDataToESP(val);
    showInSnackBar('Sending ${val ? 'ON' : 'OFF'} command');
  }

  void sendText(String value, HomeState state) async {
    state.sendTextToESP(value);
    showInSnackBar('Sending $value');
  }

  void showSettingsPage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
            create: (_) => SettingState(), child: SettingsPage()),
        fullscreenDialog: true));
  }
}
