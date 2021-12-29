import 'package:shared_preferences/shared_preferences.dart';

import 'local_persistance_interface.dart';

class MySharedPreferences implements LocalPersistanceService {
  SharedPreferences? _prefs;

  Future<SharedPreferences?> _getInstance() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs;
  }

  @override
  Future<void> setValue<T>(String key, T value) async {
    await _setValue(key, value);
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final value = await _getValue<T>(key);
    return value;
  }

  @override
  Future<bool> containsKey(String key) async {
    final myPrefs = await _getInstance();
    return myPrefs!.containsKey(key);
  }

  @override
  Future<bool> removeValue(String key) async {
    final myPrefs = await _getInstance();
    return myPrefs!.remove(key);
  }

  @override
  Future<bool> removeAll() async {
    final myPrefs = await _getInstance();
    return myPrefs!.clear();
  }

  Future<void> _setValue<T>(String key, T value) async {
    final myPrefs = await _getInstance();
    switch (T) {
      case String:
        await myPrefs!.setString(key, (value as String));
        break;
      case bool:
        await myPrefs!.setBool(key, (value as bool));
        break;
      case double:
        await myPrefs!.setDouble(key, (value as double));
        break;
      case int:
        await myPrefs!.setInt(key, (value as int));
        break;
      default:
        throw 'Error: Invalid type in [saveValue]';
    }
  }

  Future<T?> _getValue<T>(String key) async {
    final myPrefs = await _getInstance();
    switch (T) {
      case String:
        return myPrefs!.getString(key) as T?;
      case bool:
        final value = myPrefs!.getBool(key);
        return value as T?;
      case double:
        return myPrefs!.getDouble(key) as T?;
      case int:
        return myPrefs!.getInt(key) as T?;
      default:
        throw 'Error: Invalid type [getValue]';
    }
  }
}
