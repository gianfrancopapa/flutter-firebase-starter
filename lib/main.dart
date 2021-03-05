import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebasestarter/app.dart';
import 'package:firebasestarter/locator.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';

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
