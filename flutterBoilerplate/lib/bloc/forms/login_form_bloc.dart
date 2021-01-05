import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/login/login_event.dart';
import 'package:flutterBoilerplate/bloc/login/login_state.dart';
import 'package:flutterBoilerplate/mixins/validation_mixin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LoginFormBloc extends Bloc<LoginEvent, LoginState>
    with ValidationMixin {
  @protected
  final emailController = BehaviorSubject<String>.seeded('');
  @protected
  final passwordController = BehaviorSubject<String>.seeded('');

  LoginFormBloc() : super(const NotDetermined());

  Stream<String> get email => emailController.transform(emailTransfomer);
  Stream<String> get password =>
      passwordController.transform(passwordTransfomer);
  Stream<bool> get activateButton => Rx.combineLatest2<String, String, bool>(
        email,
        password,
        (email, password) => true,
      );

  Function(void) get onEmailChanged => emailController.sink.add;
  Function(void) get onPasswordChanged => passwordController.sink.add;

  Stream<LoginState> login();
  Stream<LoginState> logout();
}
