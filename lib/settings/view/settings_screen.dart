import 'package:firebasestarter/constants/assets.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/services/app_info/app_info_service.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:firebasestarter/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) =>
            AppVersionCubit(appInfo: context.read<AppInfoService>())
              ..appVersion(),
        child: const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _localizedStrings = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: _localizedStrings.settings),
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (_, current) => current.status == LoginStatus.loggedOut,
        listener: (BuildContext context, LoginState state) {
          if (state.status == LoginStatus.loggedOut) {
            Navigator.of(context).popUntil((route) => route.isFirst);
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
                    context.read<LoginBloc>().add(const LogoutRequested()),
              ),
              Margin(0.0, 200.0),
              const AppVersion(),
              Margin(0.0, 20.45),
              SvgPicture.asset(
                Assets.somnioGreyLogoSvg,
                color: AppColor.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
