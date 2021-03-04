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

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  LoginBloc _loginBloc;

  @override
  void didChangeDependencies() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.didChangeDependencies();
  }

  Widget _somnioLogo() => SvgPicture.asset(
        Assets.somnioGreyLogoSvg,
        color: AppColor.grey,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(title: AppLocalizations.of(context).settings),
        body: BlocListener<LoginBloc, LoginState>(
          cubit: _loginBloc,
          listener: (BuildContext context, LoginState state) {
            if (state.runtimeType == LoggedOut) {
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
                  text: AppLocalizations.of(context).logout,
                  onTap: () => _loginBloc.add(const StartLogout()),
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
