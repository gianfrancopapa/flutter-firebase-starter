import 'package:firebasestarter/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/bloc/init_app/init_app_bloc.dart';
import 'package:firebasestarter/bloc/init_app/init_app_state.dart';
import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:firebasestarter/screens/auth/login_screen.dart';
import 'package:firebasestarter/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetermineAccessScreen extends StatelessWidget {
  Widget _checkIfUserIsLoggedIn() => BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          switch (state.runtimeType) {
            case LoginSuccess:
              return HomeScreen((state as LoginSuccess).currentUser);
            default:
              return LoginScreen();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitAppBloc, InitAppState>(
      builder: (context, initAppState) {
        switch (initAppState.runtimeType) {
          case InitAppFirstTime:
            return OnBoardingScreen();
          case InitAppNotFirstTime:
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
}
