import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/login/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/onboarding/onboarding.dart';

class OnboardingPages extends StatelessWidget {
  const OnboardingPages({Key key}) : super(key: key);

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
            style: const TextStyle(color: FSColors.black, fontSize: 25),
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
      image: BuildImage(
        asset: asset,
      ),
      decoration: PageDecoration(
        pageColor: color,
        imagePadding: EdgeInsets.zero,
      ),
    );
  }

  List<PageViewModel> _pages(BuildContext context) {
    final _localizedStrings = AppLocalizations.of(context);
    return [
      _page(
        title: _localizedStrings.welcome,
        bodyText: _localizedStrings.pageOne,
        asset: Asset(
          name: FSAssetImage.somnioLogo,
          width: 160.0,
          height: 160.0,
        ),
        color: FSColors.white,
      ),
      _page(
        title: _localizedStrings.options,
        bodyText: _localizedStrings.pageTwo,
        asset: Asset(
          name: FSAssetImage.onboarding2,
          width: 120.0,
          height: 120.0,
        ),
        color: FSColors.white,
      ),
      _page(
        title: _localizedStrings.documentationOnConfluence,
        bodyText: _localizedStrings.pageThree,
        asset: Asset(
          name: FSAssetImage.onboarding3,
          width: null,
          height: 30.0,
        ),
        color: FSColors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state.status == OnboardingStatus.completed) {
          Navigator.of(context).pushReplacement(LoginScreen.route());
        } else if (state.status == OnboardingStatus.initial) {
          context.read<OnboardingCubit>().initOnboarding();
        }
      },
      child: Scaffold(
        body: IntroductionScreen(
          pages: _pages(context),
          onDone: () {
            context.read<OnboardingCubit>().completedOnboarding();
          },
          onSkip: () {
            context.read<OnboardingCubit>().completedOnboarding();
          },
          showSkipButton: true,
          skipFlex: 0,
          nextFlex: 0,
          skip: Text(localizations.skip),
          next: const Icon(Icons.arrow_forward),
          done: Text(
            localizations.done,
            style: const TextStyle(
              fontWeight: FSFontWeight.semiBold,
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
      ),
    );
  }
}

class BuildImage extends StatelessWidget {
  final Asset asset;

  const BuildImage({Key key, this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Image.asset(
        asset.name,
        width: asset.width,
        height: asset.height,
      ),
      alignment: Alignment.bottomCenter,
    );
  }
}
