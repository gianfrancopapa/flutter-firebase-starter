import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/login/login_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/utils/app_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutterBoilerplate/widgets/common/button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<LoginBloc>(context);
    return BlocListener(
      cubit: _bloc,
      listener: (context, state) {
        if (state.runtimeType == LoggedOut) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).settings)),
        body: Container(
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
                onTap: () => _bloc.add(const StartLogout()),
              ),
              ListTile(
                enabled: false,
                title: Text(
                  AppLocalizations.of(context).version,
                  style: TextStyle(color: Colors.grey[200]),
                ),
                trailing: FutureBuilder(
                  future: AppData().getVersionNumber(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) =>
                          Text(
                    snapshot.hasData ? snapshot.data : 'Loading ...',
                    style: TextStyle(color: Colors.grey[200]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
