import 'package:flutterBoilerplate/services/facebook_auth.dart';
import 'package:flutterBoilerplate/models/datatypes/storage_service_type.dart';
import 'package:flutterBoilerplate/services/firebase_persistance_service.dart';
import 'package:flutterBoilerplate/services/firebase_storage.dart';
import 'package:flutterBoilerplate/services/google_auth.dart';
import 'package:flutterBoilerplate/services/persistance_service_interface.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';
import 'package:flutterBoilerplate/models/datatypes/auth_service_type.dart';
import 'package:flutterBoilerplate/models/datatypes/persistance_service_type.dart';
import 'package:flutterBoilerplate/services/storage_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Singleton
class ServiceFactory {
  static final ServiceFactory _instance = ServiceFactory._internal();

  final String _authServiceKey = 'auth_service';
  final String _storageServiceKey = 'storage_service';
  SharedPreferences _prefs;

  PersistanceServiceType _persistanceServiceType =
      PersistanceServiceType.Firebase;

  ServiceFactory._internal();

  factory ServiceFactory() => _instance;

  Future<SharedPreferences> _getSharedPreferencesInstance() async {
    if (_prefs == null) {
      return SharedPreferences.getInstance();
    }
    return _prefs;
  }

  Future<IAuth> getAuthService(AuthServiceType type) async {
    _prefs = await _getSharedPreferencesInstance();
    switch (type) {
      case AuthServiceType.Firebase:
        await _prefs.setString(_authServiceKey, 'firebase');
        return FirebaseAuthService();
        break;
      case AuthServiceType.Google:
        await _prefs.setString(_authServiceKey, 'google');
        return GoogleAuthService();
        break;
      case AuthServiceType.Facebook:
        await _prefs.setString(_authServiceKey, 'facebook');
        return FacebookAuthService();
        break;
      case AuthServiceType.CurrentAuth:
        return _getCurrentAuthService();
        break;
      default:
        throw 'Error: cannot find specified type in [ServiceFactory.getAuthService]';
    }
  }

  Future<IStorage> getStorageService(StorageServiceType type) async {
    _prefs = await _getSharedPreferencesInstance();
    switch (type) {
      case StorageServiceType.Firebase:
        await _prefs.setString(_storageServiceKey, 'firebase');
        return FirebaseStorageService();
        break;
      case StorageServiceType.CurrentStorage:
        return _getCurrentStorageService();
        break;
      default:
        throw 'Error: cannot find specified type in [ServiceFactory.getAuthService]';
    }
  }

  Future<IAuth> _getCurrentAuthService() async {
    _prefs = await _getSharedPreferencesInstance();
    final currentAuth = _prefs.getString(_authServiceKey);
    if (currentAuth == null) {
      return null;
    } else if (currentAuth == 'firebase') {
      return FirebaseAuthService();
    } else if (currentAuth == 'google') {
      return GoogleAuthService();
    }
    return FacebookAuthService();
  }

  Future<IStorage> _getCurrentStorageService() async {
    _prefs = await _getSharedPreferencesInstance();
    final currentAuth = _prefs.getString(_authServiceKey);
    if (currentAuth == 'firebase') {
      return FirebaseStorageService();
    }
    return null;
  }

  IPersistanceService getPersistanceService(
    PersistanceServiceType type,
    String path,
  ) {
    switch (type) {
      case PersistanceServiceType.Firebase:
        _persistanceServiceType = PersistanceServiceType.Firebase;
        return FirebasePersistanceService(path);
      default:
        throw 'Error: cannot find specified type in [ServiceFactory.getPersistanceService]';
    }
  }

  Future<void> clearCurrentAuth() async {
    _prefs = await _getSharedPreferencesInstance();
    await _prefs.setString(_authServiceKey, null);
  }

  Future<void> clearStorageAuth() async {
    _prefs = await _getSharedPreferencesInstance();
    await _prefs.setString(_storageServiceKey, null);
  }

  PersistanceServiceType get persistanceServiceType => _persistanceServiceType;
}
