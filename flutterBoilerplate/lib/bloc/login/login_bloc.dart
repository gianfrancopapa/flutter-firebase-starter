import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/forms/login_form_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';

class LoginBloc extends LoginFormBloc {
  final _firebaseAuth = FirebaseAuthService();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    switch (event.runtimeType) {
      case StartLogin:
        yield* login();
        break;
      case StartLogout:
        yield* logout();
        break;
      case CheckIfUserIsLoggedIn:
        yield* _checkIfUserIsLoggedIn();
        break;
      default:
        yield const ErrorLogin('Undetermined event');
    }
  }

  @protected
  @override
  Stream<LoginState> login() async* {
    yield const Loading();
    try {
      await _firebaseAuth.loginWithEmail(
        emailController.value,
        passwordController.value,
      );
      yield const LoggedIn();
    } catch (e) {
      yield ErrorLogin(e);
    }
  }

  @protected
  @override
  Stream<LoginState> logout() async* {
    yield const Loading();
    try {
      await _firebaseAuth.logout();
      yield const LoggedOut();
    } catch (e) {
      yield const ErrorLogin('Error while trying to log out');
    }
  }

  Stream<LoginState> _checkIfUserIsLoggedIn() async* {
    yield const Loading();
    try {
      final user = await _firebaseAuth.checkIfUserIsLoggedIn();
      if (user != null) {
        yield const LoggedIn();
      } else {
        yield const LoggedOut();
      }
    } catch (e) {
      yield const ErrorLogin(
          'Error while trying to verify if user is logged in');
    }
  }
}
