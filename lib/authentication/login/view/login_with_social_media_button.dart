import 'package:auth/auth.dart';
import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/gen/assets.gen.dart';
import 'package:firebasestarter/l10n/l10n.dart';
import 'package:firebasestarter/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LoginWithSocialMediaButton extends StatelessWidget {
  const LoginWithSocialMediaButton({Key? key}) : super(key: key);

  AuthenticationMethod get socialMediaMethod;

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
  const LoginWithGoogleButton({Key? key}) : super(key: key);

  @override
  AuthenticationMethod get socialMediaMethod => AuthenticationMethod.google;

  @override
  String get asset =>
      Assets.packages.firebaseStarterUi.assets.images.googleLogo.path;

  @override
  String text(BuildContext context) {
    return context.l10n.googleSignIn;
  }
}

class LoginWithFacebookButton extends LoginWithSocialMediaButton {
  const LoginWithFacebookButton({Key? key}) : super(key: key);

  @override
  AuthenticationMethod get socialMediaMethod => AuthenticationMethod.facebook;

  @override
  String get asset =>
      Assets.packages.firebaseStarterUi.assets.images.facebookLogo.path;

  @override
  String text(BuildContext context) {
    return context.l10n.facebookSignIn;
  }
}

class LoginWithAppleButton extends LoginWithSocialMediaButton {
  const LoginWithAppleButton({Key? key}) : super(key: key);

  @override
  AuthenticationMethod get socialMediaMethod => AuthenticationMethod.apple;

  @override
  String get asset =>
      Assets.packages.firebaseStarterUi.assets.images.appleLogo.path;

  @override
  String text(BuildContext context) {
    return context.l10n.appleIdSignIn;
  }
}

class LoginAnonymouslyButton extends StatelessWidget {
  const LoginAnonymouslyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _localizations = context.l10n;

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
          Image(
            image: AssetImage(
                Assets.packages.firebaseStarterUi.assets.images.anonLogin.path),
            height: 30.0,
            width: 30.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
          ),
          Text(
            _localizations.anonymousSignIn,
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
