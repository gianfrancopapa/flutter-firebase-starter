import 'package:flutterBoilerplate/services/firebase_persistance_service.dart';
import 'package:flutterBoilerplate/services/persistance_service_interface.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';
import 'package:flutterBoilerplate/models/datatypes/auth_service_type.dart';
import 'package:flutterBoilerplate/models/datatypes/persistance_service_type.dart';

//Singleton
class ServiceFactory {
  static final ServiceFactory _instance = ServiceFactory._internal();

  ServiceFactory._internal();

  factory ServiceFactory() => _instance;

  IAuth getAuthService(AuthServiceType type) {
    switch (type) {
      case AuthServiceType.Firebase:
        return FirebaseAuthService();
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
        return FirebasePersistanceService(path: path);
      default:
        throw 'Error: cannot find specified type in [ServiceFactory.getPersistanceService]';
    }
  }
}
