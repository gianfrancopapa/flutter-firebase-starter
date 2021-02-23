import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/constants/themes/app_theme.dart';
import 'package:flutterBoilerplate/screens/determine_access_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    super.initState();
  }

  Widget _loading() => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );

  Widget _error() => const Scaffold(
        body: Center(
          child: Text('Something went wrong'),
        ),
      );

  @override
  Widget build(BuildContext context) => MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('es', ''),
        ],
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: FutureBuilder<FirebaseApp>(
          future: Firebase.initializeApp(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return DetermineAccessScreen();
            } else if (snapshot.hasError) {
              return _error();
            } else
              return _loading();
          },
        ),
      );
}
