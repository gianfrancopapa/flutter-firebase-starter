import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/forgot_password/view/forgot_password_screen.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:firebasestarter/login/view/login_provider_buttons_section.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/home/view/home_screen.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            current.status == LoginStatus.loggedIn,
        listener: (BuildContext context, LoginState state) {
          if (state.status == LoginStatus.failure) {
            DialogHelper.showAlertDialog(
              context: context,
              story: _determineAccessError(state.error, context),
              btnText: 'Close',
              btnAction: () => Navigator.pop(context),
            );
          }

          if (state.status == LoginStatus.loggedIn) {
            context.read<UserBloc>().add(const UserLoaded());

            Navigator.of(context).push(HomeScreen.route());
          }
        },
        child: const _LoginForm(
          key: Key('loginScreen_loginForm'),
        ),
      ),
    );
  }

  String _determineAccessError(AuthError error, BuildContext context) {
    var message = 'Error: ';
    final _appLocalizations = AppLocalizations.of(context);
    switch (error) {
      case AuthError.INVALID_EMAIL:
        message += _appLocalizations.invalidEmail;
        break;
      case AuthError.USER_DISABLED:
        message += _appLocalizations.userDisabled;
        break;
      case AuthError.USER_NOT_FOUND:
        message += _appLocalizations.userNotFound;
        break;
      case AuthError.WRONG_PASSWORD:
        message += _appLocalizations.wrongPassword;
        break;
      case AuthError.EMAIL_ALREADY_IN_USE:
        message += _appLocalizations.emailAlreadyInUse;
        break;
      case AuthError.INVALID_CREDENTIAL:
        message += _appLocalizations.invalidCredential;
        break;
      case AuthError.OPERATION_NOT_ALLOWED:
        message += _appLocalizations.operationNotAllowed;
        break;
      case AuthError.WEAK_PASSWORD:
        message += _appLocalizations.weakPassword;
        break;
      default:
        message += 'An error occurs';
    }
    return message;
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((LoginBloc bloc) => bloc.state.user);

    return user == null
        ? const CircularProgressIndicator()
        : Padding(
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
                  const _EmailTextField(
                    key: Key('loginScreen_loginForm_emailTextField'),
                  ),
                  Margin(0, 20.0),
                  const _PasswordTextField(
                    key: Key('loginScreen_loginForm_passwordTextField'),
                  ),
                  Margin(0, 27.5),
                  const _ForgotPasswordButton(
                    key: Key('loginScreen_loginForm_forgotPasswordButton'),
                  ),
                  Margin(0, 21.0),
                  const _LoginButton(
                    key: Key('loginScreen_loginForm_loginButton'),
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

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final email = context.select((LoginBloc bloc) => bloc.state.email);

    return TextField(
      decoration: InputDecoration(
        labelText: localizations.email,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorText: email.valid ? null : 'Invalid email',
      ),
      onChanged: (email) {
        context.read<LoginBloc>().add(LoginEmailChanged(email: email));
      },
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final password = context.select((LoginBloc bloc) => bloc.state.password);

    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: localizations.password,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorText: password.valid ? null : 'Invalid password',
      ),
      onChanged: (password) {
        context.read<LoginBloc>().add(LoginPasswordChanged(password: password));
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final status = context.select((LoginBloc bloc) => bloc.state.status);
    final isNotValid = status != LoginStatus.valid;

    return Button(
      backgroundColor: isNotValid ? AppColor.grey : AppColor.blue,
      text: localizations.login,
      onTap: isNotValid
          ? null
          : () {
              context
                  .read<LoginBloc>()
                  .add(const LoginWithEmailAndPasswordRequested());
            },
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
    );
  }
}
