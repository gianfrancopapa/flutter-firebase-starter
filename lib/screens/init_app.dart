import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/bloc/init_app/init_app_bloc.dart';
import 'package:firebasestarter/bloc/init_app/init_app_state.dart';
import 'package:firebasestarter/login/view/login_screen.dart';
import 'package:firebasestarter/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash.dart';

class DetermineAccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final status = context.select((InitAppBloc bloc) => bloc.state.status);

    if (status == InitAppStatus.firstTime) return OnBoardingScreen();

    if (status == InitAppStatus.notFirstTime) {
      return const _DetermineAccessScreen();
    }

    return Splash();
  }
}

class _DetermineAccessScreen extends StatelessWidget {
  const _DetermineAccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginBloc>().state;

    if (state.status == LoginStatus.initial) return Splash();

    if (state.status == LoginStatus.loggedIn) return HomeScreen(state.user);

    return const LoginScreen();
  }
}
