import 'package:flutterBoilerplate/models/datatypes/storage_service_type.dart';
import 'package:flutterBoilerplate/services/firebase_persistance_service.dart';
import 'package:flutterBoilerplate/services/firebase_storage.dart';
import 'package:flutterBoilerplate/services/persistance_service_interface.dart';
import 'package:flutterBoilerplate/models/datatypes/persistance_service_type.dart';
import 'package:flutterBoilerplate/services/storage_interface.dart';

//Singleton
class ServiceFactory {
  static final ServiceFactory _instance = ServiceFactory._internal();

  PersistanceServiceType _persistanceServiceType =
      PersistanceServiceType.Firebase;

  ServiceFactory._internal();

  factory ServiceFactory() => _instance;

  Future<IStorage> getStorageService(StorageServiceType type) async {
    switch (type) {
      case StorageServiceType.Firebase:
        final _storageServiceType = FirebaseStorageService();
        return _storageServiceType;
      default:
        throw 'Error: cannot find specified type in [ServiceFactory.getPersistanceService]';
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
