import 'package:auth/auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebasestarter/employees/employees.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/services/analytics/analyitics.dart';
import 'package:firebasestarter/services/app_info/app_info_service.dart';
import 'package:firebasestarter/services/image_picker/image_picker.dart';
import 'package:firebasestarter/services/notifications/notifications_service.dart';
import 'package:firebasestarter/services/shared_preferences/shared_preferences.dart';
import 'package:firebasestarter/services/storage/firebase_storage_service.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:repository/repository.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required FirebaseAuthService authService,
    required MySharedPreferences sharedPreferences,
    required FirebaseAnalyticsService firebaseAnalyticsService,
    required FirebaseStorageService firebaseStorageService,
    required NotificationService notificationService,
    required AppInfoService appInfoService,
    required PickImageService pickImageService,
    required FirebaseAnalytics firebaseAnalytics,
    required EmployeesRepository employeesRepository,
  })  : _authService = authService,
        _sharedPreferences = sharedPreferences,
        _firebaseAnalyticsService = firebaseAnalyticsService,
        _firebaseStorageService = firebaseStorageService,
        _notificationService = notificationService,
        _appInfoService = appInfoService,
        _pickImageService = pickImageService,
        _firebaseAnalytics = firebaseAnalytics,
        _employeesRepository = employeesRepository,
        super(key: key);

  final FirebaseAuthService _authService;
  final MySharedPreferences _sharedPreferences;
  final FirebaseAnalyticsService _firebaseAnalyticsService;
  final FirebaseStorageService _firebaseStorageService;
  final NotificationService _notificationService;
  final AppInfoService _appInfoService;
  final PickImageService _pickImageService;
  final FirebaseAnalytics _firebaseAnalytics;
  final EmployeesRepository _employeesRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _sharedPreferences),
        RepositoryProvider.value(value: _authService),
        RepositoryProvider.value(value: _firebaseAnalyticsService),
        RepositoryProvider.value(value: _firebaseStorageService),
        RepositoryProvider.value(value: _notificationService),
        RepositoryProvider.value(value: _appInfoService),
        RepositoryProvider.value(value: _pickImageService),
        RepositoryProvider.value(value: _firebaseAnalytics),
        RepositoryProvider.value(value: _employeesRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (_) => AppBloc(
              authService: _authService,
              localPersistanceService: _sharedPreferences,
            )..add(const AppIsFirstTimeLaunched()),
          ),
          BlocProvider<LoginBloc>(
            create: (_) => LoginBloc(
              authService: _authService,
              analyticsService: _firebaseAnalyticsService,
            )..add(const LoginIsSessionPersisted()),
          ),
          BlocProvider(
            create: (_) =>
                UserBloc(authService: _authService)..add(const UserLoaded()),
          ),
          BlocProvider(
            create: (_) => EmployeesBloc(_employeesRepository)
              ..add(const EmployeesLoaded()),
          ),
        ],
        child: FirebaseStarter(
          firebaseAnalytics: _firebaseAnalytics,
        ),
      ),
    );
  }
}

class FirebaseStarter extends StatelessWidget {
  const FirebaseStarter({
    Key? key,
    required FirebaseAnalytics firebaseAnalytics,
  })  : _firebaseAnalytics = firebaseAnalytics,
        super(key: key);

  final FirebaseAnalytics _firebaseAnalytics;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const DetermineAccessScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: _firebaseAnalytics,
        ),
      ],
    );
  }
}
