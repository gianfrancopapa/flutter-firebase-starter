import 'package:flutterBoilerplate/services/firebase_persistance_service.dart';
import 'package:flutterBoilerplate/services/google_auth.dart';
import 'package:flutterBoilerplate/services/persistance_service_interface.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';
import 'package:flutterBoilerplate/models/datatypes/auth_service_type.dart';
import 'package:flutterBoilerplate/models/datatypes/persistance_service_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Singleton
class ServiceFactory {
  static final ServiceFactory _instance = ServiceFactory._internal();
  AuthServiceType _currentAuthServiceType;
  IAuth _currentAuthService;
  PersistanceServiceType _persistanceServiceType =
      PersistanceServiceType.Firebase;

  ServiceFactory._internal();
  final String _authService = 'auth_service';

  factory ServiceFactory() => _instance;

  Future<IAuth> getAuthService(AuthServiceType type) async {
    final prefs = await SharedPreferences.getInstance();
    switch (type) {
      case AuthServiceType.Firebase:
        prefs.setString(_authService, type.toString());
        return FirebaseAuthService();
        break;
      case AuthServiceType.Google:
        prefs.setString(_authService, type.toString());
        return GoogleAuthService();
        break;
      default:
        throw 'Error: cannot find specified type in [ServiceFactory.getAuthService]';
    }
  }

  Future<AuthServiceType> getCurrentAuthService() async {
    final prefs = await SharedPreferences.getInstance();
    final currentAuth = prefs.getString(_authService);
    try {
      if (AuthServiceType.Firebase.toString() == currentAuth) {
        _currentAuthServiceType = AuthServiceType.Firebase;
      } else if (AuthServiceType.Google.toString() == currentAuth) {
        _currentAuthServiceType = AuthServiceType.Google;
      }
    } catch (e) {
      throw e;
    }
    return _currentAuthServiceType;
  }

  Future<IAuth> getCurrentAuthServiceIAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final currentAuth = prefs.getString(_authService);
    try {
      if (AuthServiceType.Firebase.toString() == currentAuth) {
        _currentAuthService = FirebaseAuthService();
      } else if (AuthServiceType.Google.toString() == currentAuth) {
        _currentAuthService = GoogleAuthService();
      }
    } catch (e) {
      throw e;
    }
    return _currentAuthService;
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

  PersistanceServiceType get persistanceServiceType => _persistanceServiceType;
}
