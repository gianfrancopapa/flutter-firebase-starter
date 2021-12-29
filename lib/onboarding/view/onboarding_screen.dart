import 'package:firebasestarter/onboarding/onboarding.dart';
import 'package:firebasestarter/services/analytics/firebase_analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Asset {
  String? name;
  double? width;
  double? height;

  Asset({this.name, this.width, this.height});
}

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => OnboardingCubit(
          analyticsService: context.read<FirebaseAnalyticsService>(),
        ),
        child: const OnBoardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const OnboardingPages();
  }
}
