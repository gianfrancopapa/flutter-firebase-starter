import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebasestarter/constants/weights.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/screens/auth/login_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:firebasestarter/constants/assets.dart';
import 'package:firebasestarter/constants/weights.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OnBoardingScreenState();
  }
}

class OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset(
        assetName,
        width: 350.0,
        height: 350.0,
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  PageViewModel _page({
    String title,
    String bodyText,
    String asset,
    Color color,
  }) {
    return PageViewModel(
      titleWidget: AutoSizeText(
        title,
        maxLines: 1,
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ),
      bodyWidget: Padding(
        padding: const EdgeInsets.all(30.0),
        child: AutoSizeText(
          bodyText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF929794),
          ),
        ),
      ),
      image: _buildImage(asset),
      decoration: PageDecoration(
        pageColor: color,
        imagePadding: EdgeInsets.zero,
      ),
    );
  }

  List<PageViewModel> _pages() => [
        _page(
          title: AppLocalizations.of(context).welcome,
          bodyText: AppLocalizations.of(context).pageOne,
          asset: Assets.somnioLogo,
          color: Colors.white,
        ),
        _page(
          title: AppLocalizations.of(context).options,
          bodyText: AppLocalizations.of(context).pageTwo,
          asset: Assets.onboarding2,
          color: Colors.white,
        ),
        _page(
          title: AppLocalizations.of(context).documentationOnConfluence,
          bodyText: AppLocalizations.of(context).pageThree,
          asset: Assets.onboarding3,
          color: Colors.white,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: _pages(),
        onDone: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ),
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: Text(AppLocalizations.of(context).skip),
        next: const Icon(Icons.arrow_forward),
        done: Text(
          AppLocalizations.of(context).done,
          style: TextStyle(
            fontWeight: AppWeights.semiBold,
          ),
        ),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
