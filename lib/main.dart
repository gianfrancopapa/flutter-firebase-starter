import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebasestarter/app.dart';
import 'package:firebasestarter/app/bloc_observer.dart';
import 'package:firebasestarter/locator.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  initServices();
  GetIt.I.get<AnalyticsService>().logAppOpen();

  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.i.webInitialize(
      appId: '234963458267270',
      cookie: true,
      xfbml: true,
      version: 'v9.0',
    );
  }

  runApp(const App());
}
