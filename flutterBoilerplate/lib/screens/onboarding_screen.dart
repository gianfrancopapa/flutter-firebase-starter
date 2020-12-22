import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/screens/login_screen.dart';
import 'package:sk_onboarding_screen/sk_onboarding_model.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';
import 'package:flutterBoilerplate/constants/assets.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OnBoardingScreenState();
  }
}

class OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: SKOnboardingScreen(
        bgColor: Colors.white,
        themeColor: const Color(0xFFf74269),
        pages: pages,
        skipClicked: (value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
        getStartedClicked: (value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
        },
      ),
    );
  }

  final pages = [
    SkOnboardingModel(
        title: 'Welcome to Flutter Boilerplate',
        description:
            'A Somnios\'s applications to to be reused when creating a new app',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: Assets.somnioLogo),
    SkOnboardingModel(
        title: 'Options',
        description:
            'Explore and reuse generic functions to let you start coding, as soon as possible',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: Assets.onboarding2),
    SkOnboardingModel(
        title: 'Documentation on Confluence',
        description:
            'You can find some documentation on Confluence in order to find information about this app',
        titleColor: Colors.black,
        descripColor: const Color(0xFF929794),
        imagePath: Assets.onboarding3),
  ];
}
