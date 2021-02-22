import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/forms/login_form_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';

class LoginBloc extends LoginFormBloc {
  final _auth = FirebaseAuthService();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    switch (event.runtimeType) {
      case StartLogin:
        yield* login();
        break;
      case StartGoogleLogin:
        yield* googleLogin();
        break;
      case StartAppleLogin:
        yield* appleLogin();
        break;
      case StartFacebookLogin:
        yield* facebookLogin();
        break;
      case StartAnonymousLogin:
        yield* anonymousLogin();
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
      final user = await _auth.loginWithEmail(
          emailController.value, passwordController.value);
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  @protected
  Stream<LoginState> googleLogin() async* {
    yield const Loading();
    try {
      final user = await _auth.loginWithGoogle();
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  @protected
  Stream<LoginState> appleLogin() async* {
    yield const Loading();
    try {
      final user = await _auth.loginWithApple();
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  @protected
  Stream<LoginState> facebookLogin() async* {
    yield const Loading();
    try {
      final user = await _auth.loginWithFacebook();
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  @protected
  Stream<LoginState> anonymousLogin() async* {
    yield const Loading();
    try {
      final user = await _auth.loginAnonymously();
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  @protected
  @override
  Stream<LoginState> logout() async* {
    yield const Loading();
    try {
      await _auth.logout();
      yield const LoggedOut();
    } catch (e) {
      yield const ErrorLogin('Error while trying to log out');
    }
  }

  Stream<LoginState> _checkIfUserIsLoggedIn() async* {
    yield const Loading();
    try {
      final user = await _auth.checkIfUserIsLoggedIn();
      if (user != null) {
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
