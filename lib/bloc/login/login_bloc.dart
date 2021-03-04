import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/bloc/forms/login_form_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:get_it/get_it.dart';

class LoginBloc extends LoginFormBloc {
  final _auth = FirebaseAuthService();
  AnalyticsService _analyticsService;
  LoginBloc() {
    _analyticsService = GetIt.I.get<AnalyticsService>();
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    switch (event.runtimeType) {
      case StartLogin:
        yield* login();
        break;
      case StartGoogleLogin:
        yield* signIn(_auth.signInWithGoogle, 'google');
        break;
      case StartAppleLogin:
        yield* signIn(_auth.signInWithApple, 'apple');
        break;
      case StartFacebookLogin:
        yield* signIn(_auth.signInWithFacebook, 'facebook');
        break;
      case StartAnonymousLogin:
        yield* signIn(_auth.signInAnonymously, 'anonymous');
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
    _analyticsService.logLogin('email');
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
  Stream<LoginState> signIn(
      Future<User> Function() signInMethod, String loginMethod) async* {
    _analyticsService.logLogin(loginMethod);
    yield const Loading();
    try {
      final user = await signInMethod();
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  @protected
  @override
  Stream<LoginState> logout() async* {
    _analyticsService.logLogout();
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
