import 'package:firebasestarter/bloc/forgot_password/forgot_password_state.dart';
import 'package:firebasestarter/widgets/settings/app_version.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/loading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context, listen: false);
    super.initState();
  }

  Widget _body() {
    return BlocConsumer(
      cubit: _loginBloc,
      listener: (context, state) {
        if (state.runtimeType == LoggedOut) {
          // TODO: Replace
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      builder: (BuildContext context, LoginState state) {
        if (state.runtimeType == LoggedIn) {
          return Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
            alignment: Alignment.bottomCenter,
            height: MediaQuery.of(context).size.height / 2.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Button(
                  backgroundColor: Colors.white,
                  textColor: Colors.teal,
                  text: AppLocalizations.of(context).logout,
                  onTap: () => _loginBloc.add(const StartLogout()),
                ),
                const SizedBox(height: 10),
                AppVersion(),
              ],
            ),
          );
        }
        return const LoadingIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).settings)),
      body: _body(),
    );
  }
}
