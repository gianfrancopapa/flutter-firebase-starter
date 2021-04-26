import 'package:firebasestarter/constants/assets.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:firebasestarter/widgets/settings/app_version.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SettingsScreen extends StatelessWidget {
  Widget _somnioLogo() => SvgPicture.asset(
        Assets.somnioGreyLogoSvg,
        color: AppColor.grey,
      );

  @override
  Widget build(BuildContext context) {
    final _localizedStrings = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: _localizedStrings.settings),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (BuildContext context, LoginState state) {
          if (state.runtimeType == LogoutSuccess) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Button(
                height: 52.0,
                backgroundColor: AppColor.blue,
                text: _localizedStrings.logout,
                onTap: () =>
                    context.read<LoginBloc>().add(const LogoutStarted()),
              ),
              Margin(0.0, 200.0),
              AppVersion(),
              Margin(0.0, 20.45),
              _somnioLogo(),
            ],
          ),
        ),
      ),
    );
  }
}
