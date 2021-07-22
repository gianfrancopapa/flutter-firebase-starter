import 'package:firebasestarter/onboarding/cubit/onboarding_cubit.dart';
import 'package:firebasestarter/onboarding/view/onboarding_pages.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class Asset {
  String name;
  double width;
  double height;

  Asset({this.name, this.width, this.height});
}

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            OnboardingCubit(analyticsService: GetIt.I.get<AnalyticsService>()),
        child: const OnboardingPages());
  }
}
