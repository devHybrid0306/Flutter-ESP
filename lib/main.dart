import 'package:esp_connect/screen/HomeScreen.dart';
import 'package:esp_connect/services/service_locator.dart';
import 'package:esp_connect/state/home_screen_state.dart';
import 'package:esp_connect/state/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP CONNECT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => HomeState(),
          ),
          ChangeNotifierProvider(
            create: (_) => SettingState(),
          ),
        ],
        child: HomeScreen(),
      ),
    );
  }
}
