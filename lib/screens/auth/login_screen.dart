import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/screens/auth/forgot_password_screen.dart';
import 'package:firebasestarter/widgets/auth/login_provider_buttons_section.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/screens/home.dart';
import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//TODO: Localize screen completely

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightGrey,
      appBar: const CustomAppBar(
        title: 'Login',
        goBack: false,
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (_, current) =>
            current.status == LoginStatus.failure ||
            current.status == LoginStatus.loginSuccess,
        listener: (BuildContext context, LoginState state) {
          if (state.status == LoginStatus.failure) {
            DialogHelper.showAlertDialog(
              context: context,
              story: _determineAccessError(state, context),
              btnText: 'Close',
              btnAction: () => Navigator.pop(context),
            );
          }

          if (state.status == LoginStatus.loginSuccess) {
            context.read<UserBloc>().add(const UserLoaded());

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(state.currentUser),
              ),
            );
          }
        },
        child: const _LoginForm(),
      ),
    );
  }

//TODO: Refactor this
  String _determineAccessError(LoginState exception, BuildContext context) {
    const error = 'Error:';
    var message;
    final _appLocalizations = AppLocalizations.of(context);
    switch (exception.errorMessage) {
      case 'invalid-email':
        message = _appLocalizations.invalidEmail;
        break;
      case 'user-disabled':
        message = _appLocalizations.userDisabled;
        break;
      case 'user-not-found':
        message = _appLocalizations.userNotFound;
        break;
      case 'wrong-password':
        message = _appLocalizations.wrongPassword;
        break;
      case 'email-already-in-use':
      case 'account-exists-with-different-credential':
        message = _appLocalizations.emailAlreadyInUse;
        break;
      case 'invalid-credential':
        message = _appLocalizations.invalidCredential;
        break;
      case 'operation-not-allowed':
        message = _appLocalizations.operationNotAllowed;
        break;
      case 'weak-password':
        message = _appLocalizations.weakPassword;
        break;
      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
        message = _appLocalizations.missingAuthToken;
        break;
      default:
        message = 'An error occurs';
    }
    return error + ' ' + message;
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _localizedStrings = AppLocalizations.of(context);

    final emailAddress =
        context.select((LoginBloc bloc) => bloc.state.emailAddress);
    final password = context.select((LoginBloc bloc) => bloc.state.password);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Margin(0, 47.0),
            InkWell(
              onTap: () {
                Navigator.of(context).push(ForgotPasswordScreen.route());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.of(context).createAccount,
                    style: const TextStyle(
                      color: AppColor.skyBlue,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: AppColor.skyBlue,
                    size: 15.0,
                  )
                ],
              ),
            ),
            Margin(0, 12.0),
            TextFieldBuilder(
                value: emailAddress ?? '',
                labelText: _localizedStrings.email,
                onChanged: (email) {
                  context
                      .read<LoginBloc>()
                      .add(EmailAddressUpdated(emailAddress: email));
                }),
            Margin(0, 20.0),
            TextFieldBuilder(
              value: password ?? '',
              labelText: _localizedStrings.password,
              onChanged: (password) {
                context
                    .read<LoginBloc>()
                    .add(PasswordUpdated(password: password));
              },
              isPassword: true,
              showPasswordButton: true,
            ),
            Margin(0, 27.5),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(ForgotPasswordScreen.route());
              },
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  AppLocalizations.of(context).didYouForgetYourPassword,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColor.blue,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Margin(0, 21.0),
            Center(
              child: Button(
                  backgroundColor: AppColor.blue,
                  text: _localizedStrings.login,
                  onTap: () {
                    context.read<LoginBloc>().add(const LoginStarted());
                  }),
            ),
            Margin(0, 26.0),
            Center(
              child: SizedBox(
                height: 20.0,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: AppColor.grey,
                      height: 0.5,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 5.0,
                      ),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: AppColor.grey,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      color: AppColor.grey,
                      height: 0.5,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ],
                ),
              ),
            ),
            Margin(0, 20.0),
            const Center(
              child: LoginProviderButtonsSection(),
            ),
            Margin(0, 40.0),
          ],
        ),
      ),
    );
  }
}
