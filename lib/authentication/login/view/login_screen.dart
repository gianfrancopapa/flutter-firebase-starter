import 'package:auth/auth.dart';
import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/gen/assets.gen.dart';
import 'package:firebasestarter/l10n/l10n.dart';
import 'package:firebasestarter/authentication/authentication.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:firebasestarter/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/home/home.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

LoginState _loginState = LoginState.initial();

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
    final _localizations = context.l10n;
    switch (error) {
      case AuthError.invalidEmail:
        message += _localizations.invalidEmail;
        break;
      case AuthError.userDisabled:
        message += _localizations.userDisabled;
        break;
      case AuthError.userNotFound:
        message += _localizations.userNotFound;
        break;
      case AuthError.wrongPassword:
        message += _localizations.wrongPassword;
        break;
      case AuthError.emailAlreadyInUse:
        message += _localizations.emailAlreadyInUse;
        break;
      case AuthError.invalidCredential:
        message += _localizations.invalidCredential;
        break;
      case AuthError.operationNotAllowed:
        message += _localizations.operationNotAllowed;
        break;
      case AuthError.weakPassword:
        message += _localizations.weakPassword;
        break;
      case AuthError.expiredLink:
        message += _localizations.expiredLink;
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
    final _localizations = context.l10n;
    _loginState = context.select((LoginBloc bloc) => bloc.state);

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
                    _localizations.createAccount,
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
            const SizedBox(height: 40.0),
            TextButton(
              key: const Key('loginScreen_loginForm_otherOptions'),
              onPressed: () => _showOtherLoginOptions(context),
              child: Text(_localizations.otherLoginOptions),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showOtherLoginOptions(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => Wrap(
        children: <Widget>[
          BottomSheet(
            enableDrag: true,
            elevation: 2.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40.0),
              ),
            ),
            onClosing: () {},
            builder: (_) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 44.0, vertical: 22.0),
              child: Column(
                children: const [
                  LoginAnonymouslyButton(
                    key: Key('loginScreen_loginForm_loginAnonymouslyButton'),
                  ),
                  SizedBox(height: 14.0),
                  LoginPasswordlessButton(
                    key: Key('loginScreen_loginForm_loginPasswordlessButton'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _localizations = context.l10n;

    final email = context.select((LoginBloc bloc) => bloc.state.email);

    return TextField(
      decoration: InputDecoration(
        labelText: _localizations.email,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: FSColors.red),
        ),
        errorText: email!.valid ? null : _localizations.invalidEmail,
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
    final _localizations = context.l10n;

    final password = context.select((LoginBloc bloc) => bloc.state.password);

    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: _localizations.password,
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
    final _localizations = context.l10n;

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
        _localizations.login,
        style: const TextStyle(color: FSColors.white),
      ),
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _localizations = context.l10n;
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(ForgotPasswordScreen.route());
      },
      child: SizedBox(
        width: double.infinity,
        child: Text(
          _localizations.didYouForgetYourPassword,
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

class LoginPasswordlessButton extends StatelessWidget {
  const LoginPasswordlessButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return FSTextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(FSSpacing.s10)),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(FSColors.white),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(localizations.sendLoginEmail),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    localizations.loginEmailDescription,
                  ),
                  const SizedBox(height: 10.0),
                  const _PasswordlessEmailTextField(
                    key: Key('loginScreen_passwordlessLogin_emailTextField'),
                  ),
                ],
              ),
              actions: const [
                _SendEmailButton(
                  key: Key('loginScreen_passwordlessLogin_sendEmailButton'),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
          ),
          Image(
            image: AssetImage(Assets.packages.firebaseStarterUi.assets.images
                .passwordlessLogo.path),
            height: 30.0,
            width: 30.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0),
          ),
          Text(
            localizations.passwordlessSignIn,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              color: FSColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordlessEmailTextField extends StatelessWidget {
  const _PasswordlessEmailTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final passwordlessEmail =
        context.select((LoginBloc bloc) => bloc.state.passwordlessEmail);

    return TextField(
      decoration: InputDecoration(
        labelText: localizations.email,
        errorText: passwordlessEmail!.valid ? null : localizations.invalidEmail,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: FSColors.red),
        ),
      ),
      onChanged: (passwordlessEmail) {
        context.read<LoginBloc>().add(LoginPasswordlessEmailChanged(
            passwordlessEmail: passwordlessEmail));
      },
    );
  }
}

class _SendEmailButton extends StatelessWidget {
  const _SendEmailButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return FSTextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(FSSpacing.s10)),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(FSColors.blue),
      ),
      onPressed: () async {
        final isValid = _loginState.status == LoginStatus.passwordlessValid;

        if (isValid) {
          context.read<LoginBloc>().add(const LoginSendEmailRequested());

          DialogHelper.showAlertDialog(
            context: context,
            story: localizations.emailSent,
            btnText: localizations.ok,
            btnAction: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          );
        } else {
          DialogHelper.showAlertDialog(
            context: context,
            story: localizations.invalidEmail,
            btnText: localizations.ok,
            btnAction: () => Navigator.of(context).pop(),
          );
        }
      },
      child: Text(
        localizations.sendLoginEmail,
        style: const TextStyle(color: FSColors.white),
      ),
    );
  }
}
