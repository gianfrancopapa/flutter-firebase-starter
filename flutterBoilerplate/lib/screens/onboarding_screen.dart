import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/screens/login_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutterBoilerplate/constants/assets.dart';

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
      child: Image.asset(assetName, width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  PageViewModel _page(
      {String title, String bodyText, String asset, Color color}) {
    return PageViewModel(
      titleWidget: AutoSizeText(
        title,
        maxLines: 1,
        style: const TextStyle(color: Colors.black),
      ),
      bodyWidget: AutoSizeText(
        bodyText,
        maxLines: 2,
        style: const TextStyle(
          color: Color(0xFF929794),
        ),
      ),
      image: _buildImage(asset),
      decoration: PageDecoration(
        pageColor: color,
        imagePadding: EdgeInsets.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          _page(
            title: 'Welcome to Flutter Boilerplate',
            bodyText:
                'A Somnios\'s applications to to be reused when creating a new app',
            asset: AppAsset.somnioLogo,
            color: Colors.white,
          ),
          _page(
            title: 'Options',
            bodyText:
                'Explore and reuse generic functions to let you start coding, as soon as possible',
            asset: AppAsset.onboarding2,
            color: Colors.white,
          ),
          _page(
            title: 'Documentation on Confluence',
            bodyText:
                'You can find some documentation on Confluence in order to find information about this app',
            asset: AppAsset.onboarding3,
            color: Colors.white,
          ),
        ],
        onDone: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen())),
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: const Text('Skip'),
        next: const Icon(Icons.arrow_forward),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
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
