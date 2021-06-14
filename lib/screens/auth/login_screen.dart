import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/auth/login_form.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/screens/home.dart';
import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColor.lightGrey,
        appBar: const CustomAppBar(
          title: 'Login',
          goBack: false,
        ),
        body: BlocListener<LoginBloc, LoginState>(
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
              BlocProvider.of<UserBloc>(context)..add(const UserLoaded());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(state.currentUser),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44.0),
            child: SingleChildScrollView(
                child: LoginForm(context.read<LoginBloc>())),
          ),
        ),
      );

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
