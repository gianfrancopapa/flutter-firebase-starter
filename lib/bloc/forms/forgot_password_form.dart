import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/forgot_password/forgot_password_event.dart';
import 'package:flutterBoilerplate/bloc/forgot_password/forgot_password_state.dart';
import 'package:flutterBoilerplate/mixins/validation_mixin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ForgotPasswordFormBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState>
    with ValidationMixin {
  @protected
  final emailController = BehaviorSubject<String>.seeded('');

  ForgotPasswordFormBloc() : super(const NotDetermined());

  Stream<String> get email => emailController.transform(emailTransfomer);

  Function(void) get onEmailChanged => emailController.sink.add;

  //Stream<ForgotPasswordState> createAccountWithEmail();
}
