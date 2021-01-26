import 'package:flutterBoilerplate/services/firebase_persistance_service.dart';
import 'package:flutterBoilerplate/services/google_auth.dart';
import 'package:flutterBoilerplate/services/persistance_service_interface.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';
import 'package:flutterBoilerplate/models/datatypes/auth_service_type.dart';
import 'package:flutterBoilerplate/models/datatypes/persistance_service_type.dart';

//Singleton
class ServiceFactory {
  static final ServiceFactory _instance = ServiceFactory._internal();

  PersistanceServiceType _persistanceServiceType =
      PersistanceServiceType.Firebase;

  ServiceFactory._internal();

  factory ServiceFactory() => _instance;

  Future<IAuth> getAuthService(AuthServiceType type) async {
    switch (type) {
      case AuthServiceType.Firebase:
        return FirebaseAuthService();
        break;
      case AuthServiceType.Google:
        return GoogleAuthService();
        break;
      default:
        throw 'Error: cannot find specified type in [ServiceFactory.getAuthService]';
    }
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
