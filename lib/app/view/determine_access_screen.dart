import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/login/view/login_screen.dart';
import 'package:firebasestarter/onboarding/view/onboarding_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetermineAccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final status = context.select((AppBloc bloc) => bloc.state.status);

    if (status == AppStatus.firstTime) return OnBoardingScreen();

    if (status == AppStatus.notFirstTime) {
      return const _DetermineAccessScreen();
    }

    return const SplashScreen();
  }
}

class _DetermineAccessScreen extends StatelessWidget {
  const _DetermineAccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;

    if (state.status == LoginStatus.initial) return const SplashScreen();

    if (state.status == LoginStatus.loggedIn) return const HomeScreen();

    return const LoginScreen();
  }
}
