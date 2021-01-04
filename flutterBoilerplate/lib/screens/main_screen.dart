import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/login/login_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/screens/configuration_screen.dart';
import 'package:flutterBoilerplate/screens/user_profile_screen.dart';
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
          leading: const SizedBox(),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey,
          title: Text(AppString.welcome),
          actions: <Widget>[
            CustomButton(const Icon(Icons.miscellaneous_services_rounded),
                AppString.configuration, context, const ConfigurationScreen()),
            CustomButton(const Icon(Icons.supervised_user_circle),
                AppString.myProfile, context, ProfileScreen()),
          ],
        ),
        body: Center(
          child: Button(
            text: AppString.logout,
            onTap: () => _bloc.add(
              const StartLogout(),
            ),
          ),
        ),
      ),
    );
  }

  Widget CustomButton(
      Icon icon, String tooltip, BuildContext context, Widget screen) {
    return IconButton(
      icon: icon,
      tooltip: tooltip,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ),
    );
  }
}
