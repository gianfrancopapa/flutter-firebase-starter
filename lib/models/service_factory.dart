import 'package:firebasestarter/models/datatypes/storage_service_type.dart';
import 'package:firebasestarter/services/persistence/firebase_persistance_service.dart';
import 'package:firebasestarter/services/persistence/persistance_service_interface.dart';
import 'package:firebasestarter/models/datatypes/persistance_service_type.dart';
import 'package:firebasestarter/services/storage/storage_service.dart';
import 'package:firebasestarter/services/storage/firebase_storage_service.dart';

//Singleton
class ServiceFactory {
  static final ServiceFactory _instance = ServiceFactory._internal();

  PersistanceServiceType _persistanceServiceType =
      PersistanceServiceType.Firebase;

  ServiceFactory._internal();

  factory ServiceFactory() => _instance;

  Future<StorageService> getStorageService(StorageServiceType type) async {
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
