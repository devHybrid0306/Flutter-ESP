import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  static const SWITCH_ON_KEY = 'SWITCH_ON_KEY';
  static const SWITCH_OFF_KEY = 'SWITCH_OFF_KEY';

  int get switchOnCode => _getFromDisk(SWITCH_ON_KEY) ?? 0;

  set switchOnCode(int value) => _saveToDisk(SWITCH_ON_KEY, value);

  int get switchOffCode => _getFromDisk(SWITCH_OFF_KEY) ?? 1;

  set switchOffCode(int value) => _saveToDisk(SWITCH_OFF_KEY, value);

  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService();
    }
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  dynamic _getFromDisk(String key) {
    var value = _preferences.get(key);
    print('(TRACE) LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  void _saveToDisk<T>(String key, T content) {
    print('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }
}
