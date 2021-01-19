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
    final emailVerified = await _verifyEmail();

    try {
      if (emailVerified == true) {
        final user = await _firebaseAuth.loginWithEmail(
          emailController.value,
          passwordController.value,
        );
        yield LoggedIn(user);
      } else {
        throw Error;
      }
    } catch (e) {
      print(e);
      print(emailVerified.toString());
      yield ErrorLogin(e.toString());
    }
  }

  Future<bool> _verifyEmail() async {
    try {
      final emailVerified = await _firebaseAuth.checkIfEmailIsVerified();
      return emailVerified;
    } catch (e) {
      return true;
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
      final emailVerified = await _verifyEmail();
      final user = await _firebaseAuth.checkIfUserIsLoggedIn();
      if (user != null && emailVerified == true) {
        yield LoggedIn(user);
      } else {
        yield const LoggedOut();
      }
    } catch (e) {
      yield const ErrorLogin(
          'Error while trying to verify if user is logged in');
    }
  }
}
