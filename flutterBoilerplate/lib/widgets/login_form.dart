import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/login/login_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/constants/assets.dart';
import 'package:flutterBoilerplate/models/datatypes/auth_service_type.dart';
import 'package:flutterBoilerplate/screens/create_account_screen.dart';
import 'package:flutterBoilerplate/screens/forgot_password_screen.dart';
import 'package:flutterBoilerplate/utils/dialog.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/widgets/common/auth_service_button.dart';
import 'package:flutterBoilerplate/widgets/common/button.dart';
import 'package:flutterBoilerplate/widgets/common/text_field_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<LoginBloc>(context);
    super.didChangeDependencies();
  }

  void _dispatchLoginEvent(AuthServiceType type) => _bloc.add(StartLogin(type));

  void _onEmailChanged(String email) => _bloc.onEmailChanged(email);

  void _onPasswordChanged(String password) => _bloc.onPasswordChanged(password);

  void _goToCreateAccountScreen() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAccountScreen(),
        ),
      );

  void _goToForgotPasswordScreen() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordScreen(),
        ),
      );

  void _determineAction(LoginState state) {
    if (state.runtimeType == ErrorLogin) {
      DialogHelper.showAlertDialog(
        context: context,
        story: (state as ErrorLogin).message,
        btnText: 'Close',
        btnAction: () => Navigator.pop(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<LoginBloc, LoginState>(
        cubit: _bloc,
        listener: (context, state) => _determineAction(state),
        builder: (context, state) => ModalProgressHUD(
          inAsyncCall: state.runtimeType == Loading,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
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
                      TextFieldBuilder(
                        stream: _bloc.password,
                        labelText: AppString.password,
                        onChanged: _onPasswordChanged,
                        isPassword: true,
                      ),
                      TextButton(
                        onPressed: _goToForgotPasswordScreen,
                        child: const Text('Did you forgot your password?'),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 5,
                  ),
                  child: GestureDetector(
                    onTap: _goToCreateAccountScreen,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(AppString.dontYouHaveAccount + ' '),
                        Text(
                          AppString.createOne,
                          style: TextStyle(
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AuthServiceButton(
                      text: AppString.googleSignIn,
                      backgroundColor: Colors.grey[50],
                      textColor: Colors.grey,
                      asset: AppAsset.googleLogo,
                      onTap: () => _dispatchLoginEvent(AuthServiceType.Google),
                    ),
                  ],
                ),
                Button(
                  text: AppString.login,
                  onTap: () => _dispatchLoginEvent(AuthServiceType.Firebase),
                ),
              ],
            ),
          ),
        ),
      );
}
