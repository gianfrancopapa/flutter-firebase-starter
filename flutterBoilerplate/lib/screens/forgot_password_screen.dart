import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:flutterBoilerplate/bloc/forgot_password/forgot_password_event.dart';
import 'package:flutterBoilerplate/bloc/forgot_password/forgot_password_state.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/screens/login_screen.dart';
import 'package:flutterBoilerplate/widgets/common/button.dart';
import 'package:flutterBoilerplate/widgets/common/text_field_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordBloc _bloc;

  void _onEmailChanged(String email) => _bloc.onEmailChanged(email);

  void _dispatchForgotPasswordEvent() => _bloc.add(const ForgotPassword());

  void _goToLoginScreen() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );

  @override
  void initState() {
    _bloc = ForgotPasswordBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppString.forgotPassword),
        ),
        body: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          cubit: _bloc,
          builder: (BuildContext context, state) => Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFieldBuilder(
                        stream: _bloc.email,
                        labelText: AppString.email,
                        onChanged: _onEmailChanged,
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ),
                    ],
                  ),
                ),
                Button(text: AppString.send, onTap: () => _showMyDialog()),
              ],
            ),
          ),
        ),
      );

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppString.emailSended,
            style: const TextStyle(color: Colors.black),
          ),
          content: const Text(AppString.checkInbox,
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            FlatButton(
              child: const Text(AppString.ok,
                  style: TextStyle(color: Colors.black)),
              onPressed: () {
                _dispatchForgotPasswordEvent();
                _goToLoginScreen();
              },
            ),
          ],
        );
      },
    );
  }
}
