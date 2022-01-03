import 'package:auth/auth.dart';
import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/forgot_password/forgot_password.dart';
import 'package:firebasestarter/sign_up/sign_up.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:firebasestarter/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/home/home.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: FSColors.lightGrey,
        appBar: CustomAppBar(title: 'Login', goBack: false),
        body: BlocListener<LoginBloc, LoginState>(
          listenWhen: (prev, current) =>
              (prev.status != current.status) &&
              (current.status == LoginStatus.failure ||
                  current.status == LoginStatus.loggedIn),
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
      ),
    );
  }

  String _determineAccessError(AuthError? error, BuildContext context) {
    var message = 'Error: ';
    final _appLocalizations = AppLocalizations.of(context);
    switch (error) {
      case AuthError.invalidEmail:
        message += _appLocalizations!.invalidEmail;
        break;
      case AuthError.userDisabled:
        message += _appLocalizations!.userDisabled;
        break;
      case AuthError.userNotFound:
        message += _appLocalizations!.userNotFound;
        break;
      case AuthError.wrongPassword:
        message += _appLocalizations!.wrongPassword;
        break;
      case AuthError.emailAlreadyInUse:
        message += _appLocalizations!.emailAlreadyInUse;
        break;
      case AuthError.invalidCredential:
        message += _appLocalizations!.invalidCredential;
        break;
      case AuthError.operationNotAllowed:
        message += _appLocalizations!.operationNotAllowed;
        break;
      case AuthError.weakPassword:
        message += _appLocalizations!.weakPassword;
        break;
      default:
        message += 'An error occurs';
    }
    return message;
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 47.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(SignUpScreen.route());
                  },
                  child: Text(
                    localizations.createAccount,
                    style: const TextStyle(
                      color: FSColors.skyBlue,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: FSColors.skyBlue,
                  size: 15.0,
                )
              ],
            ),
            const SizedBox(height: 12.0),
            const _EmailTextField(
              key: Key('loginScreen_loginForm_emailTextField'),
            ),
            const SizedBox(height: 20.0),
            const _PasswordTextField(
              key: Key('loginScreen_loginForm_passwordTextField'),
            ),
            const SizedBox(height: 27.0),
            const _ForgotPasswordButton(
              key: Key('loginScreen_loginForm_forgotPasswordButton'),
            ),
            const SizedBox(height: 21.0),
            const _LoginButton(
              key: Key('loginScreen_loginForm_loginButton'),
            ),
            const SizedBox(height: 26.0),
            Center(
              child: SizedBox(
                height: 20.0,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: FSColors.grey,
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
                          color: FSColors.grey,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      color: FSColors.grey,
                      height: 0.5,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            const LoginWithGoogleButton(
              key: Key('loginScreen_loginForm_loginWithGoogleButton'),
            ),
            const SizedBox(height: 14.0),
            const LoginWithFacebookButton(
              key: Key('loginScreen_loginForm_loginWithFacebookButton'),
            ),
            const SizedBox(height: 14.0),
            const LoginWithAppleButton(
              key: Key('loginScreen_loginForm_loginWithAppleButton'),
            ),
            const SizedBox(height: 14.0),
            const LoginAnonymouslyButton(
              key: Key('loginScreen_loginForm_loginAnonymouslyButton'),
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final email = context.select((LoginBloc bloc) => bloc.state.email);

    return TextField(
      decoration: InputDecoration(
        labelText: localizations.email,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: FSColors.red),
        ),
        errorText: email!.valid ? null : 'Invalid email',
      ),
      onChanged: (email) {
        context.read<LoginBloc>().add(LoginEmailChanged(email: email));
      },
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final password = context.select((LoginBloc bloc) => bloc.state.password);

    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: localizations.password,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: FSColors.red),
        ),
        errorText: password!.valid ? null : 'Invalid password',
      ),
      onChanged: (password) {
        context.read<LoginBloc>().add(LoginPasswordChanged(password: password));
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final status = context.select((LoginBloc bloc) => bloc.state.status);
    final isNotValid = status != LoginStatus.valid;

    return FSTextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(FSSpacing.s10)),
          ),
        ),
        backgroundColor: isNotValid
            ? MaterialStateProperty.all(FSColors.grey)
            : MaterialStateProperty.all(FSColors.blue),
      ),
      onPressed: isNotValid
          ? null
          : () {
              context
                  .read<LoginBloc>()
                  .add(const LoginWithEmailAndPasswordRequested());
            },
      child: Text(
        localizations.login,
        style: const TextStyle(color: FSColors.white),
      ),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(ForgotPasswordScreen.route());
      },
      child: SizedBox(
        width: double.infinity,
        child: Text(
          AppLocalizations.of(context)!.didYouForgetYourPassword,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: FSColors.blue,
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
