import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/login/login_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/screens/login_screen.dart';
import 'package:flutterBoilerplate/screens/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  LoginBloc _bloc;
  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<LoginBloc>(context);
    _bloc.add(const CheckIfUserIsLoggedIn());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: BlocBuilder<LoginBloc, LoginState>(
          cubit: _bloc,
          builder: (context, state) {
            switch (state.runtimeType) {
              case LoggedIn:
                return MainScreen();
              default:
                return LoginScreen();
            }
          },
        ),
      );
}
