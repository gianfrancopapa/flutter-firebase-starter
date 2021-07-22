import 'package:firebase_analytics/observer.dart';
import 'package:firebasestarter/data_source/data_source.dart';
import 'package:firebasestarter/employees/employees.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/services/analytics/analyitics.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:firebasestarter/services/notifications/notifications_service.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:repository/repository.dart';
import 'services/shared_preferences/local_persistance_interface.dart';

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (_) => AppBloc(
            localPersistanceService: GetIt.I.get<LocalPersistanceService>(),
          )..add(const AppIsFirstTimeLaunched()),
        ),
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(
            authService: GetIt.I.get<AuthService>(),
            analyticsService: GetIt.I.get<AnalyticsService>(),
          )..add(const LoginIsSessionPersisted()),
        ),
        BlocProvider(
          create: (_) => UserBloc(authService: GetIt.I.get<AuthService>())
            ..add(const UserLoaded()),
        ),
        BlocProvider(
          create: (_) => EmployeesBloc(
            EmployeesRepository(
              FirebaseEmployeeDatabase(),
            ),
          )..add(const EmployeesLoaded()),
        ),
      ],
      child: const FirebaseStarter(),
    );
  }
}

class FirebaseStarter extends StatefulWidget {
  const FirebaseStarter({Key key}) : super(key: key);

  @override
  _FirebaseStarterState createState() => _FirebaseStarterState();
}

class _FirebaseStarterState extends State<FirebaseStarter> {
  NotificationService _notificationService;

  @override
  void initState() {
    _notificationService = GetIt.I<NotificationService>();
    _notificationService.configure();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: DetermineAccessScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: GetIt.I.get<AnalyticsService>().getService(),
        ),
      ],
    );
  }
}
