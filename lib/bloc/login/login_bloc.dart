import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/bloc/forms/login_form_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';

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
    FirebaseAnalyticsService.instance.logLogin(loginMethod: 'email');
    yield const Loading();
    try {
      final user = await _auth.signInWithEmailAndPassword(
        emailController.value,
        passwordController.value,
      );
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  @protected
  Stream<LoginState> googleLogin() async* {
    FirebaseAnalyticsService.instance.logLogin(loginMethod: 'google');
    yield const Loading();
    try {
      final user = await _auth.signInWithGoogle();
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  @protected
  Stream<LoginState> appleLogin() async* {
    FirebaseAnalyticsService.instance.logLogin(loginMethod: 'apple');
    yield const Loading();
    try {
      final user = await _auth.signInWithApple();
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  @protected
  Stream<LoginState> facebookLogin() async* {
    FirebaseAnalyticsService.instance.logLogin(loginMethod: 'facebook');
    yield const Loading();
    try {
      final user = await _auth.signInWithFacebook();
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  @protected
  Stream<LoginState> anonymousLogin() async* {
    FirebaseAnalyticsService.instance.logLogin(loginMethod: 'anonymous');
    yield const Loading();
    try {
      final user = await _auth.signInAnonymously();
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  @protected
  @override
  Stream<LoginState> logout() async* {
    FirebaseAnalyticsService.instance.logEvent(name: 'logout');
    yield const Loading();
    try {
      await _auth.signOut();
      yield const LoggedOut();
    } catch (e) {
      yield const ErrorLogin('Error while trying to log out');
    }
  }

  Stream<LoginState> _checkIfUserIsLoggedIn() async* {
    yield const Loading();
    try {
      final user = await _auth.currentUser();
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
