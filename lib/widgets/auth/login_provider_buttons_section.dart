import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/constants/assets.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/widgets/auth/auth_service_button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:flutter/material.dart';

class LoginProviderButtonsSection extends StatelessWidget {
  static const _text = 'text';
  static const _asset = 'asset';
  static const _onTap = 'onTap';
  static const _last = 'last';

  final LoginBloc bloc;

  const LoginProviderButtonsSection(this.bloc);

  List<Map<String, dynamic>> get _buttonsData => [
        {
          _text: Strings.googleSignIn,
          _asset: Assets.googleLogo,
          _onTap: () => bloc.add(const StartGoogleLogin()),
          _last: false,
        },
        {
          _text: Strings.login,
          _asset: Assets.facebookLogo,
          _onTap: () => bloc.add(const StartFacebookLogin()),
          _last: false,
        },
        {
          _text: Strings.login,
          _asset: Assets.appleLogo,
          _onTap: () => bloc.add(const StartAppleLogin()),
          _last: false,
        },
        {
          _text: Strings.login,
          _asset: Assets.anonLogin,
          _onTap: () => bloc.add(const StartAnonymousLogin()),
          _last: true,
        }
      ];

  @override
  Widget build(BuildContext context) => Column(
        children: [
          for (final info in _buttonsData) ...[
            AuthServiceButton(
              text: info[_text],
              backgroundColor: Colors.white,
              textColor: Colors.black,
              asset: info[_asset],
              onTap: info[_onTap],
            ),
            !info[_last]
                ? Margin(0.0, 14.0)
                : const SizedBox(height: 0.0, width: 0.0),
          ]
        ],
      );
}
