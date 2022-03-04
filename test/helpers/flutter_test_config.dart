import 'dart:async';
import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/employees/employees.dart';
import 'package:firebasestarter/authentication/authentication.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUpAll(() {});

  await testMain();
}

class FakeEmployeesEvent extends Fake implements EmployeesEvent {}

class FakeInitAppEvent extends Fake implements AppEvent {}

class FakeLoginEvent extends Fake implements LoginEvent {}

class FakeUserEvent extends Fake implements UserEvent {}

class FakeAccountCreationEvent extends Fake implements SignUpEvent {}

class FakeEditProfileEvent extends Fake implements EditProfileEvent {}

class FakeForgotPasswordEvent extends Fake implements ForgotPasswordEvent {}

class FakeEmployeesState extends Fake implements EmployeesState {}

class FakeInitAppState extends Fake implements AppState {}

class FakeLoginState extends Fake implements LoginState {}

class FakeUserState extends Fake implements UserState {}

class FakeAccountCreationState extends Fake implements SignUpState {}

class FakeEditProfileState extends Fake implements EditProfileState {}

class FakeForgotPasswordState extends Fake implements ForgotPasswordState {}
