import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/mixins/validation_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

abstract class UserFormBloc<E, S> extends Bloc<E, S> with ValidationMixin {
  @protected
  final firstNameController = BehaviorSubject<String>.seeded('');
  @protected
  final lastNameController = BehaviorSubject<String>.seeded('');
  @protected
  final emailController = BehaviorSubject<String>.seeded('');
  @protected
  final ageController = BehaviorSubject<double>.seeded(0);
  @protected
  final phoneController = BehaviorSubject<String>.seeded('');
  @protected
  final addressController = BehaviorSubject<String>.seeded('');
  @protected
  final isAdminController = BehaviorSubject<bool>.seeded(false);

  UserFormBloc(S initialState) : super(initialState);

  Stream<String> get firstName =>
      firstNameController.transform(alphabeticTransfomer);

  Stream<String> get lastName =>
      lastNameController.transform(alphabeticTransfomer);

  Stream<String> get email => emailController.transform(emailTransfomer);

  Stream<double> get age => ageController.stream;

  Stream<String> get phone => phoneController.transform(numericTransfomer);

  Stream<String> get address =>
      addressController.stream.transform(alphabeticTransfomer);

  Stream<bool> get isAdmin => isAdminController.stream;

  Function(void) get onFirstNameChanged => firstNameController.sink.add;

  Function(void) get onLastNameChanged => lastNameController.sink.add;

  Function(void) get onEmailChanged => emailController.sink.add;

  Function(void) get onAgeChanged => ageController.sink.add;

  Function(void) get onPhoneChanged => phoneController.sink.add;

  Function(void) get onAddressChanged => addressController.sink.add;

  Function(void) get onIsAdmingChanged => isAdminController.sink.add;

  Stream<bool> get activateButton =>
      Rx.combineLatest5<String, String, String, String, String, bool>(
        firstName,
        lastName,
        email,
        phone,
        address,
        (email, firstName, phone, lastName, address) => true,
      );

  @override
  Future<void> close() {
    firstNameController.close();
    lastNameController.close();
    emailController.close();
    ageController.close();
    phoneController.close();
    addressController.close();
    isAdminController.close();
    return super.close();
  }
}
