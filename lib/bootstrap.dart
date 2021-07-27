import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebasestarter/app/bloc_observer.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/services/auth/sign_in_services/apple/apple_credentials.dart';
import 'package:firebasestarter/services/auth/sign_in_services/apple/apple_sign_in_service.dart';
import 'package:firebasestarter/services/auth/sign_in_services/facebook/facebook_sign_in_service.dart';
import 'package:firebasestarter/services/auth/sign_in_services/google/google_sign_in_service.dart';
import 'package:firebasestarter/services/auth/sign_in_services/sign_in_services_factory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppBlocObserver extends BlocObserver {}

void bootstrap(Future<Widget> Function() builder) async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.i.webInitialize(
      appId: '234963458267270',
      cookie: true,
      xfbml: true,
      version: 'v9.0',
    );
  }

  final _serviceFactory = SignInServiceFactory();

  _serviceFactory.addService(
    method: SocialMediaMethod.APPLE,
    constructor: () =>
        AppleSignInService(appleCredentials: const AppleCredentials()),
  );

  _serviceFactory.addService(
    method: SocialMediaMethod.FACEBOOK,
    constructor: () => FacebookSignInService(
      facebookAuth: FacebookAuth.instance,
    ),
  );

  _serviceFactory.addService(
    method: SocialMediaMethod.GOOGLE,
    constructor: () => GoogleSignInService(
      googleSignIn: GoogleSignIn(),
    ),
  );

  await runZonedGuarded<Future<void>>(
    () async => runApp(await builder()),
    FirebaseCrashlytics.instance.recordError,
  );
}
