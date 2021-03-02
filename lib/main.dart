import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebasestarter/app.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseAnalyticsService.instance.logAppOpen();
  runApp(App());
}
