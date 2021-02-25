import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/mixins/validation_mixin.dart';
import 'package:flutterBoilerplate/models/datatypes/working_area.dart';
import 'package:flutterBoilerplate/utils/enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

abstract class EmployeeFormBloc<E, S> extends Bloc<E, S> with ValidationMixin {
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
  final descriptionController = BehaviorSubject<String>.seeded('');
  @protected
  final workingAreaController = BehaviorSubject<String>.seeded('');
  @protected
  final workingAreaListController = BehaviorSubject<List<String>>.seeded(
    <String>[],
  );

  EmployeeFormBloc(S initialState) : super(initialState) {
    onWorkingAreaListChanged(
      WorkingArea.values
          .map<String>(
            (workingArea) => Enum.getEnumValue(workingArea),
          )
          .toList(),
    );
    workingAreaController.sink.add(Enum.getEnumValue(WorkingArea.Development));
  }

  Stream<String> get firstName =>
      firstNameController.transform(alphabeticTransfomer);

  Stream<String> get lastName =>
      lastNameController.transform(alphabeticTransfomer);

  Stream<String> get email => emailController.transform(emailTransfomer);

  Stream<double> get age => ageController.stream;

  Stream<String> get phone => phoneController.transform(numericTransfomer);

  Stream<String> get address =>
      addressController.stream.transform(alphabeticTransfomer);

  Stream<String> get description => descriptionController.stream;

  Stream<String> get workingArea => workingAreaController.stream;

  Stream<List<String>> get workingAreaList => workingAreaListController.stream;

  void Function(void) get onFirstNameChanged => firstNameController.sink.add;

  void Function(void) get onLastNameChanged => lastNameController.sink.add;

  void Function(void) get onEmailChanged => emailController.sink.add;

  void Function(void) get onAgeChanged => ageController.sink.add;

  void Function(void) get onPhoneChanged => phoneController.sink.add;

  void Function(void) get onAddressChanged => addressController.sink.add;

  void Function(void) get onDescriptionChanged =>
      descriptionController.sink.add;

  void Function(void) get onWorkingAreaChanged =>
      workingAreaController.sink.add;

  Function(void) get onWorkingAreaListChanged =>
      workingAreaListController.sink.add;

  Stream<bool> get activateButton => Rx.combineLatest7<String, String, String,
          String, String, double, String, bool>(
        firstName,
        lastName,
        email,
        phone,
        address,
        age,
        description,
        (email, firstName, phone, lastName, address, age, description) =>
            age > 0,
      );

  @protected
  Future<void> clearFields() async {
    ageController.sink.add(0);
    ageController.sink.add(0.0);
    firstNameController.sink.add('');
    lastNameController.sink.add('');
    emailController.sink.add('');
    addressController.sink.add('');
    phoneController.sink.add('');
    descriptionController.sink.add('');
    workingAreaController.sink.add(Enum.getEnumValue(WorkingArea.Other));
  }

  @override
  Future<void> close() {
    firstNameController.close();
    lastNameController.close();
    emailController.close();
    ageController.close();
    phoneController.close();
    addressController.close();
    descriptionController.close();
    workingAreaController.close();
    workingAreaListController.close();
    return super.close();
  }
}
