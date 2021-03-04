import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebasestarter/app.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/analytics/firebase_analytics_service.dart';
import 'package:firebasestarter/services/app_info/app_info.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';
import 'package:firebasestarter/services/image_picker/image_picker_service.dart';
import 'package:firebasestarter/services/image_picker/image_service.dart';
import 'package:firebasestarter/services/storage/firebase_storage_service.dart';
import 'package:firebasestarter/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  initServices();
  GetIt.I.get<AnalyticsService>().logAppOpen();
  runApp(App());
}

void initServices() {
  GetIt.I.registerSingleton<AnalyticsService>(FirebaseAnalyticsService());
  GetIt.I.registerLazySingleton<AppInfo>(() => AppInfo());
  GetIt.I.registerLazySingleton<AuthService>(() => FirebaseAuthService());
  GetIt.I.registerLazySingleton<ImageService>(() => PickImageService());
  GetIt.I.registerLazySingleton<StorageService>(() => FirebaseStorageService());
}
