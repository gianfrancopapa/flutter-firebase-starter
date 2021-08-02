import 'package:auth/auth.dart';
import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class LoginWithSocialMediaButton extends StatelessWidget {
  const LoginWithSocialMediaButton({Key key}) : super(key: key);

  SocialMediaMethod get socialMediaMethod;

  String get asset;

  String text(BuildContext context);

  void _onTap(BuildContext context) {
    context
        .read<LoginBloc>()
        .add(LoginWithSocialMediaRequested(method: socialMediaMethod));
  }

  @override
  Widget build(BuildContext context) {
    return FSTextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(FSSpacing.s10)),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(FSColors.white),
      ),
      onPressed: () {
        _onTap(context);
      },
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
          ),
          Image(
            image: AssetImage(asset),
            height: 30.0,
            width: 30.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
          ),
          Text(
            text(context),
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: FSColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class LoginWithGoogleButton extends LoginWithSocialMediaButton {
  const LoginWithGoogleButton({Key key}) : super(key: key);

  @override
  SocialMediaMethod get socialMediaMethod => SocialMediaMethod.GOOGLE;

  @override
  String get asset => FSAssetImage.googleLogo;

  @override
  String text(BuildContext context) {
    return AppLocalizations.of(context).googleSignIn;
  }
}

class LoginWithFacebookButton extends LoginWithSocialMediaButton {
  const LoginWithFacebookButton({Key key}) : super(key: key);

  @override
  SocialMediaMethod get socialMediaMethod => SocialMediaMethod.FACEBOOK;

  @override
  String get asset => FSAssetImage.facebookLogo;

  @override
  String text(BuildContext context) {
    return AppLocalizations.of(context).facebookSignIn;
  }
}

class LoginWithAppleButton extends LoginWithSocialMediaButton {
  const LoginWithAppleButton({Key key}) : super(key: key);

  @override
  SocialMediaMethod get socialMediaMethod => SocialMediaMethod.APPLE;

  @override
  String get asset => FSAssetImage.appleLogo;

  @override
  String text(BuildContext context) {
    return AppLocalizations.of(context).appleIdSignIn;
  }
}

class LoginAnonymouslyButton extends StatelessWidget {
  const LoginAnonymouslyButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return FSTextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(FSSpacing.s10)),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(FSColors.white),
      ),
      onPressed: () {
        context.read<LoginBloc>().add(const LoginAnonymouslyRequested());
      },
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
          ),
          const Image(
            image: AssetImage(FSAssetImage.anonLogin),
            height: 30.0,
            width: 30.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
          ),
          Text(
            localizations.anonymousSignIn,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: FSColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
