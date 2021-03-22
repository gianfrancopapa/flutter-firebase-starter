import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/analytics/firebase_analytics_service.dart';
import 'package:firebasestarter/services/app_info/app_info.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';
import 'package:firebasestarter/services/image_picker/image_picker_service.dart';
import 'package:firebasestarter/services/image_picker/image_service.dart';
import 'package:firebasestarter/services/notifications/notifications_service.dart';
import 'package:firebasestarter/services/shared_preferences/local_persistance_interface.dart';
import 'package:firebasestarter/services/shared_preferences/shared_preferences.dart';
import 'package:firebasestarter/services/storage/firebase_storage_service.dart';
import 'package:firebasestarter/services/storage/storage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:google_sign_in/google_sign_in.dart';

final getIt = GetIt.instance;

void initServices() {
  final _firebaseAuth = Auth.FirebaseAuth.instance;
  GetIt.I.registerSingleton<AnalyticsService>(FirebaseAnalyticsService());
  GetIt.I.registerLazySingleton<AppInfo>(() => AppInfo());
  GetIt.I.registerLazySingleton<AuthService>(
      () => FirebaseAuthService(_firebaseAuth));
  GetIt.I.registerLazySingleton<ImageService>(() => PickImageService());
  GetIt.I.registerLazySingleton<StorageService>(() => FirebaseStorageService());
  GetIt.I.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );
  GetIt.I.registerLazySingleton<LocalPersistanceService>(
    () => MySharedPreferences(),
  );
}
