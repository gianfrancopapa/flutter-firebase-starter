import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/forms/login_form_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/models/datatypes/auth_service_type.dart';
import 'package:flutterBoilerplate/models/service_factory.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';

class LoginBloc extends LoginFormBloc {
  IAuth _authService;
  final _serviceFactory = ServiceFactory();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    switch (event.runtimeType) {
      case StartLogin:
        _authService =
            await _serviceFactory.getAuthService((event as StartLogin).type);
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
      final user = await _authService.loginWithEmail(
        emailController.value,
        passwordController.value,
      );
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
      _serviceFactory.clearCurrentAuth();
      await _authService.logout();
      yield const LoggedOut();
    } catch (e) {
      yield const ErrorLogin('Error while trying to log out');
    }
  }

  Stream<LoginState> _checkIfUserIsLoggedIn() async* {
    yield const Loading();
    try {
      _authService =
          await _serviceFactory.getAuthService(AuthServiceType.CurrentAuth);
      if (_authService == null) {
        yield const Loading();
      }
      final user = await _authService.checkIfUserIsLoggedIn();
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
