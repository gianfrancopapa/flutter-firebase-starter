import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/create_account/create_account_event.dart';
import 'package:flutterBoilerplate/bloc/create_account/create_account_state.dart';
import 'package:flutterBoilerplate/mixins/validation_mixin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CreateAccountFormBloc
    extends Bloc<CreateAccountEvent, CreateAccountState> with ValidationMixin {
  @protected
  final firstNameController = BehaviorSubject<String>.seeded('');
  @protected
  final lastNameController = BehaviorSubject<String>.seeded('');
  @protected
  final emailController = BehaviorSubject<String>.seeded('');
  @protected
  final passwordController = BehaviorSubject<String>.seeded('');
  @protected
  final passwordConfirmationController = BehaviorSubject<String>.seeded('');

  CreateAccountFormBloc() : super(const NotDetermined());

  Stream<String> get firstName =>
      firstNameController.transform(alphabeticTransfomer);

  Stream<String> get lastName =>
      lastNameController.transform(alphabeticTransfomer);

  Stream<String> get email => emailController.transform(emailTransfomer);

  Stream<String> get password =>
      passwordController.transform(passwordTransfomer);

  Stream<String> get passwordConfirmation =>
      passwordConfirmationController.transform(passwordTransfomer);

  Function(void) get onFirstNameChanged => firstNameController.sink.add;

  Function(void) get onLastNameChanged => lastNameController.sink.add;

  Function(void) get onEmailChanged => emailController.sink.add;

  Function(void) get onPasswordChanged => passwordController.sink.add;

  Function(void) get onPasswordConfirmationChanged =>
      passwordConfirmationController.sink.add;

  Stream<bool> get activateButton => Rx.combineLatest2<String, String, bool>(
        email,
        password,
        (email, password) => true,
      );

  Stream<CreateAccountState> createAccountWithEmail();
}
