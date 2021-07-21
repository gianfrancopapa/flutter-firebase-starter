import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/constants/assets.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:firebasestarter/widgets/auth/auth_service_button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginProviderButtonsSection extends StatelessWidget {
  static const _text = 'text';
  static const _asset = 'asset';
  static const _onTap = 'onTap';
  static const _last = 'last';

  const LoginProviderButtonsSection({Key key}) : super(key: key);

  List<Map<String, dynamic>> _buttonsData(context) {
    final localization = AppLocalizations.of(context);
    return [
      {
        _text: localization.googleSignIn,
        _asset: Assets.googleLogo,
        _onTap: () {
          context.read<LoginBloc>().add(
                const LoginWithSocialMediaRequested(
                  method: SocialMediaMethod.GOOGLE,
                ),
              );
        },
        _last: false,
      },
      {
        _text: localization.facebookSignIn,
        _asset: Assets.facebookLogo,
        _onTap: () {
          context.read<LoginBloc>().add(
                const LoginWithSocialMediaRequested(
                  method: SocialMediaMethod.FACEBOOK,
                ),
              );
        },
        _last: false,
      },
      {
        _text: localization.appleIdSignIn,
        _asset: Assets.appleLogo,
        _onTap: () {
          context.read<LoginBloc>().add(
                const LoginWithSocialMediaRequested(
                  method: SocialMediaMethod.APPLE,
                ),
              );
        },
        _last: false,
      },
      {
        _text: localization.anonymousSignIn,
        _asset: Assets.anonLogin,
        _onTap: () {
          context.read<LoginBloc>().add(const LoginAnonymouslyRequested());
        },
        _last: true,
      }
    ];
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          for (final info in _buttonsData(context)) ...[
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
