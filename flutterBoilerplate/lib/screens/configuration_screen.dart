import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/login/login_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/utils/app_data.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/widgets/common/button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigurationScreen extends StatelessWidget {
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
        appBar: AppBar(
          title: const Text(
            AppString.configuration,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.grey[500],
        ),
        body: Center(
          child: Button(
            text: AppString.logout,
            onTap: () => _bloc.add(const StartLogout()),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: ListTile(
            enabled: false,
            title: const Text(AppString.version),
            trailing: FutureBuilder(
              future: AppData().getVersionNumber(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                  Text(
                snapshot.hasData ? snapshot.data : 'Loading ...',
                style: const TextStyle(color: Colors.black38),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
