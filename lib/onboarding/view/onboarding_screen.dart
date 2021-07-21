import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebasestarter/constants/weights.dart';
import 'package:firebasestarter/screens/auth/login_screen.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:firebasestarter/constants/assets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Asset {
  String name;
  double width;
  double height;

  Asset({this.name, this.width, this.height});
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OnBoardingScreenState();
  }
}

class OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  AnalyticsService _analyticsService;
  @override
  void initState() {
    //TODO: refactor this to use RepositoryProvider

    _analyticsService = GetIt.I.get<AnalyticsService>();
    _analyticsService.logTutorialBegin();
    super.initState();
  }

  Widget _buildImage(Asset asset) {
    return Align(
      child: Image.asset(
        asset.name,
        width: asset.width,
        height: asset.height,
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  PageViewModel _page({
    String title,
    String bodyText,
    Asset asset,
    Color color,
  }) {
    return PageViewModel(
      titleWidget: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: AutoSizeText(
            title,
            maxLines: 2,
            style: const TextStyle(color: Colors.black, fontSize: 25),
          )),
      bodyWidget: Padding(
        padding: const EdgeInsets.all(10.0),
        child: AutoSizeText(
          bodyText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF929794),
            fontSize: 15,
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

  List<PageViewModel> _pages() {
    final _localizedStrings = AppLocalizations.of(context);
    return [
      _page(
        title: _localizedStrings.welcome,
        bodyText: _localizedStrings.pageOne,
        asset: Asset(name: Assets.somnioLogo, width: 160.0, height: 160.0),
        color: Colors.white,
      ),
      _page(
        title: _localizedStrings.options,
        bodyText: _localizedStrings.pageTwo,
        asset: Asset(name: Assets.onboarding2, width: 120.0, height: 120.0),
        color: Colors.white,
      ),
      _page(
        title: _localizedStrings.documentationOnConfluence,
        bodyText: _localizedStrings.pageThree,
        asset: Asset(name: Assets.onboarding3, width: null, height: 30.0),
        color: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: IntroductionScreen(
        pages: _pages(),
        onDone: () {
          _analyticsService.logTutorialComplete();

          return Navigator.of(context).pushReplacement(LoginScreen.route());
        },
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: Text(localizations.skip),
        next: const Icon(Icons.arrow_forward),
        done: Text(
          localizations.done,
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
