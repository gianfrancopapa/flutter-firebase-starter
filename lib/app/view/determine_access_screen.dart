import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/home/home.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/onboarding/onboarding.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetermineAccessScreen extends StatelessWidget {
  const DetermineAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (prev, current) => prev.status != current.status,
      listener: (context, state) {
        if (state.status == AppStatus.authenticated) {
          Navigator.of(context).push(HomeScreen.route());
        }

        if (state.status == AppStatus.firstTime) {
          Navigator.of(context).push(OnBoardingScreen.route());
        }

        if (state.status == AppStatus.unauthenticated) {
          Navigator.of(context).push(LoginScreen.route());
        }
      },
      child: const SplashScreen(),
    );
  }
}
