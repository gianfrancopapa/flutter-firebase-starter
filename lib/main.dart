import 'package:auth/auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasestarter/app.dart';
import 'package:firebasestarter/bootstrap.dart';
import 'package:firebasestarter/data_source/firebase_employee_database.dart';
import 'package:firebasestarter/services/analytics/firebase_analytics_service.dart';
import 'package:firebasestarter/services/app_info/app_info_service.dart';
import 'package:firebasestarter/services/image_picker/image_picker.dart';
import 'package:firebasestarter/services/notifications/notifications_service.dart';
import 'package:firebasestarter/services/shared_preferences/shared_preferences.dart';
import 'package:firebasestarter/services/storage/firebase_storage_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:repository/repository.dart';

void main() async {
  bootstrap(
    () async {
      final _serviceFactory = SignInServiceFactory();

      _serviceFactory.addService(
        method: SocialMediaMethod.apple,
        constructor: () =>
            AppleSignInService(appleCredentials: const AppleCredentials()),
      );

      _serviceFactory.addService(
        method: SocialMediaMethod.facebook,
        constructor: () => FacebookSignInService(
          facebookAuth: FacebookAuth.instance,
        ),
      );

      _serviceFactory.addService(
        method: SocialMediaMethod.google,
        constructor: () => GoogleSignInService(
          googleSignIn: GoogleSignIn(),
        ),
      );

      return App(
        sharedPreferences: MySharedPreferences(),
        firebaseAnalytics: FirebaseAnalytics.instance,
        firebaseAnalyticsService: FirebaseAnalyticsService(),
        pickImageService: PickImageService(),
        appInfoService: AppInfoService(),
        firebaseStorageService: FirebaseStorageService(),
        employeesRepository: EmployeesRepository(FirebaseEmployeeDatabase()),
        notificationService: NotificationService(),
        authService: FirebaseAuthService(
          authService: FirebaseAuth.instance,
          signInServiceFactory: _serviceFactory,
        ),
      );
    },
  );
}
