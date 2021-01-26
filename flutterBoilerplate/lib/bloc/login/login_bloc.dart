import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/forms/login_form_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/models/service_factory.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';
import 'package:flutterBoilerplate/services/google_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends LoginFormBloc {
  IAuth _authService;
  final _serviceFactory = ServiceFactory();
  final String _authServiceKey = 'auth_service';

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    final prefs = await SharedPreferences.getInstance();
    switch (event.runtimeType) {
      case StartLogin:
        _authService =
            await _serviceFactory.getAuthService((event as StartLogin).type);
        prefs.setString(_authServiceKey, _authService.toString());
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
      if (emailVerified) {
        final user = await _authService.loginWithEmail(
          emailController.value,
          passwordController.value,
        );
        yield LoggedIn(user);
      } else {
        throw Error;
      }
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  Future<bool> _verifyEmail() async {
    try {
      final emailVerified = await _authService.checkIfEmailIsVerified();
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
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_authServiceKey, null);
      await _authService.logout();
      yield const LoggedOut();
    } catch (e) {
      yield const ErrorLogin('Error while trying to log out');
    }
  }

  Stream<LoginState> _checkIfUserIsLoggedIn() async* {
    yield const Loading();
    _getCurrentAuthService();
    try {
      if (_authService == null) {
        yield const Loading();
        return;
      }
      final user = await _authService.checkIfUserIsLoggedIn();
      final emailVerified = await _verifyEmail();
      if (user != null && emailVerified) {
        yield LoggedIn(user);
      } else {
        yield const LoggedOut();
      }
    } catch (e) {
      yield const ErrorLogin(
          'Error while trying to verify if user is logged in');
    }
  }

  void _getCurrentAuthService() async {
    final prefs = await SharedPreferences.getInstance();
    final currentAuth = prefs.getString(_authServiceKey);
    if (currentAuth == null) {
      _authService = null;
    } else if (currentAuth == FirebaseAuthService().toString()) {
      _authService = FirebaseAuthService();
    }
    _authService = GoogleAuthService();
  }
}
