import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/edit_profile/edit_profile_event.dart';
import 'package:flutterBoilerplate/bloc/edit_profile/edit_profile_state.dart';
import 'package:flutterBoilerplate/mixins/validation_mixin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EditProfileFormBloc extends Cubit<EditProfileState>
    with ValidationMixin {
  @protected
  final firstNameController = BehaviorSubject<String>.seeded('');
  @protected
  final lastNameController = BehaviorSubject<String>.seeded('');
  @protected
  final passwordController = BehaviorSubject<String>.seeded('');
  @protected
  final passwordConfirmationController = BehaviorSubject<String>.seeded('');

  EditProfileFormBloc() : super(const NotDetermined());

  Stream<String> get firstName =>
      firstNameController.transform(alphabeticTransfomer);

  Stream<String> get lastName =>
      lastNameController.transform(alphabeticTransfomer);

  Stream<String> get password =>
      passwordController.transform(passwordTransfomer);

  Stream<String> get passwordConfirmation =>
      passwordConfirmationController.transform(passwordTransfomer);

  Function(void) get onFirstNameChanged => firstNameController.sink.add;

  Function(void) get onLastNameChanged => lastNameController.sink.add;

  Function(void) get onPasswordChanged => passwordController.sink.add;

  Function(void) get onPasswordConfirmationChanged =>
      passwordConfirmationController.sink.add;

  Stream<bool> get activateButton => Rx.combineLatest2<String, String, bool>(
        firstName,
        lastName,
        (firstName, lastName) => true,
      );

  //Stream<EditProfileState> editProfile();
}
