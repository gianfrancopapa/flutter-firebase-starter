import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/login/login_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/screens/configuration_screen.dart';
import 'package:flutterBoilerplate/widgets/common/button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
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
          leading: SizedBox(),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey,
          title: Text(AppString.welcome),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.miscellaneous_services_rounded),
                tooltip: AppString.configuration,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfigurationScreen()));
                })
          ],
        ),
        body: Container(
          child: Center(
            child: Button(
              text: AppString.logout,
              onTap: () => _bloc.add(
                const StartLogout(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
