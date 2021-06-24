import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/analytics/firebase_analytics_service.dart';
import 'package:firebasestarter/services/app_info/app_info.dart';
import 'package:somnio_firebase_authentication/somnio_firebase_authentication.dart';
import 'package:firebasestarter/services/image_picker/image_picker_service.dart';
import 'package:firebasestarter/services/image_picker/image_service.dart';
import 'package:firebasestarter/services/notifications/notifications_service.dart';
import 'package:firebasestarter/services/shared_preferences/local_persistance_interface.dart';
import 'package:firebasestarter/services/shared_preferences/shared_preferences.dart';
import 'package:firebasestarter/services/storage/firebase_storage_service.dart';
import 'package:firebasestarter/services/storage/storage_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void initServices() {
  GetIt.I.registerSingleton<AnalyticsService>(FirebaseAnalyticsService());
  GetIt.I.registerLazySingleton<AppInfo>(() => AppInfo());
  GetIt.I.registerLazySingleton<AuthService>(() => FirebaseAuthService());
  GetIt.I.registerLazySingleton<ImageService>(() => PickImageService());
  GetIt.I.registerLazySingleton<StorageService>(() => FirebaseStorageService());
  GetIt.I.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );
  GetIt.I.registerLazySingleton<LocalPersistanceService>(
    () => MySharedPreferences(),
  );
}
