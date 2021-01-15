import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/init_app/init_app_bloc.dart';
import 'package:flutterBoilerplate/bloc/init_app/init_app_event.dart';
import 'package:flutterBoilerplate/bloc/init_app/init_app_state.dart';
import 'package:flutterBoilerplate/bloc/login/login_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/screens/login_screen.dart';
import 'package:flutterBoilerplate/screens/main_screen.dart';
import 'package:flutterBoilerplate/screens/onboarding_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetermineAccess extends StatefulWidget {
  @override
  _DetermineAccessState createState() => _DetermineAccessState();
}

class _DetermineAccessState extends State<DetermineAccess> {
  LoginBloc _bloc;
  InitAppBloc _initAppBloc;

  @override
  void initState() {
    super.initState();
    _initAppBloc = InitAppBloc();
    _initAppBloc.add(const IsFirstTime());
  }

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<LoginBloc>(context);
    _bloc.add(const CheckIfUserIsLoggedIn());
    super.didChangeDependencies();
  }

  Widget _checkIfUserIsLoggedIn() => BlocBuilder<LoginBloc, LoginState>(
        cubit: _bloc,
        builder: (context, loginState) {
          switch (loginState.runtimeType) {
            case LoggedIn:
              return MainScreen();
            default:
              return LoginScreen();
          }
        },
      );

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<InitAppBloc, FirstTimeInAppState>(
        cubit: _initAppBloc,
        builder: (context, initAppState) {
          switch (initAppState.runtimeType) {
            case FirstTime:
              return OnBoardingScreen();
            case NoFirstTime:
              return _checkIfUserIsLoggedIn();
            default:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        },
      );
}
