import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/analytics/firebase_analytics_service.dart';
import 'package:firebasestarter/services/app_info/app_info.dart';
import 'package:firebasestarter/services/app_info/app_info_service.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:firebasestarter/services/image_picker/image_picker_service.dart';
import 'package:firebasestarter/services/image_picker/image_service.dart';
import 'package:firebasestarter/services/notifications/notifications_service.dart';
import 'package:firebasestarter/services/shared_preferences/local_persistance_interface.dart';
import 'package:firebasestarter/services/shared_preferences/shared_preferences.dart';
import 'package:firebasestarter/services/storage/firebase_storage_service.dart';
import 'package:firebasestarter/services/storage/storage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

final getIt = GetIt.instance;

void initServices() {
  final _firebaseAuth = Auth.FirebaseAuth.instance;
  final _serviceFactory = SignInServiceFactory();

  _serviceFactory.addService(
    method: SocialMediaMethod.APPLE,
    constructor: () => AppleSignInService(),
  );

  _serviceFactory.addService(
    method: SocialMediaMethod.FACEBOOK,
    constructor: () => FacebookSignInService(),
  );

  _serviceFactory.addService(
    method: SocialMediaMethod.GOOGLE,
    constructor: () => GoogleSignInService(),
  );

  GetIt.I.registerSingleton<AnalyticsService>(FirebaseAnalyticsService());
  GetIt.I.registerLazySingleton<AppInfo>(() => AppInfoService());
  GetIt.I.registerLazySingleton<AuthService>(
    () => FirebaseAuthService(
      authService: _firebaseAuth,
      signInServiceFactory: _serviceFactory,
    ),
  );
  GetIt.I.registerLazySingleton<ImageService>(() => PickImageService());
  GetIt.I.registerLazySingleton<StorageService>(() => FirebaseStorageService());
  GetIt.I.registerLazySingleton<NotificationService>(
    () => NotificationService(),
  );
  GetIt.I.registerLazySingleton<LocalPersistanceService>(
    () => MySharedPreferences(),
  );
}
