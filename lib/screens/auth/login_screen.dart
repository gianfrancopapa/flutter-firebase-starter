import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/screens/home.dart';
import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:firebasestarter/constants/assets.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/screens/auth/create_account_screen.dart';
import 'package:firebasestarter/screens/auth/forgot_password_screen.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:firebasestarter/widgets/common/auth_service_button.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<LoginBloc>(context, listen: false);
    super.initState();
  }

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

  Widget _customLoginForm() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFieldBuilder(
            stream: _bloc.email,
            labelText: AppLocalizations.of(context).email,
            onChanged: (email) => _bloc.onEmailChanged(email),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.02,
            ),
          ),
          TextFieldBuilder(
            stream: _bloc.password,
            labelText: AppLocalizations.of(context).password,
            onChanged: (password) => _bloc.onPasswordChanged(password),
            isPassword: true,
            showPasswordButton: true,
          ),
          TextButton(
            onPressed: _goToForgotPasswordScreen,
            child: Text(AppLocalizations.of(context).didYouForgotYourPassword),
          ),
          Button(
            text: AppLocalizations.of(context).login,
            onTap: () => _bloc.add(const StartLogin()),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _goToCreateAccountScreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context).dontYouHaveAccount + ' '),
                Text(
                  AppLocalizations.of(context).createOne,
                  style: TextStyle(
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      );

  Widget _socialNetworkButtons() {
    final socialNetworkButtonInfo = [
      {
        'text': Strings.googleSignIn,
        'asset': Assets.googleLogo,
        'onTap': () => _bloc.add(const StartGoogleLogin()),
      },
      {
        'text': Strings.login,
        'asset': Assets.facebookLogo,
        'onTap': () => _bloc.add(const StartFacebookLogin()),
      },
      {
        'text': Strings.login,
        'asset': Assets.appleLogo,
        'onTap': () => _bloc.add(const StartAppleLogin()),
      },
      {
        'text': Strings.login,
        'asset': Assets.anonLogin,
        'onTap': () => _bloc.add(const StartAnonymousLogin()),
      }
    ];
    return Column(
      children: [
        for (final info in socialNetworkButtonInfo) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 15.0),
            child: AuthServiceButton(
              text: info['text'],
              backgroundColor: Colors.white,
              textColor: Colors.black,
              asset: info['asset'],
              onTap: info['onTap'],
            ),
          ),
        ]
      ],
    );
  }

  Widget _body() => BlocConsumer<LoginBloc, LoginState>(
        cubit: _bloc,
        listener: (context, state) {
          if (state.runtimeType == ErrorLogin) {
            DialogHelper.showAlertDialog(
              context: context,
              story: (state as ErrorLogin).message,
              btnText: 'Close',
              btnAction: () => Navigator.pop(context),
            );
          }
          if (state.runtimeType == LoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen((state as LoggedIn).currentUser),
              ),
            );
          }
        },
        builder: (context, state) => ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Column(
                children: [
                  _customLoginForm(),
                  const SizedBox(height: 10),
                  _socialNetworkButtons(),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).login),
          backgroundColor: Colors.blueGrey,
        ),
        body: _body(),
      );
}
