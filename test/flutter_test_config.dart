import 'dart:async';
import 'package:firebasestarter/bloc/create_account/create_account_event.dart';
import 'package:firebasestarter/bloc/create_account/create_account_state.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_event.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_state.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_event.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_state.dart';
import 'package:firebasestarter/bloc/init_app/init_app_event.dart';
import 'package:firebasestarter/bloc/init_app/init_app_state.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/bloc/user/user_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:firebasestarter/bloc/employees/employees_state.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUpAll(() {
    registerFallbackValue<EmployeesState>(FakeEmployeesState());
    registerFallbackValue<EmployeesEvent>(FakeEmployeesEvent());

    registerFallbackValue<InitAppState>(FakeInitAppState());
    registerFallbackValue<InitAppEvent>(FakeInitAppEvent());

    registerFallbackValue<LoginState>(FakeLoginState());
    registerFallbackValue<LoginEvent>(FakeLoginEvent());

    registerFallbackValue<UserState>(FakeUserState());
    registerFallbackValue<UserEvent>(FakeUserEvent());

    registerFallbackValue<CreateAccountState>(FakeCreateAccountState());
    registerFallbackValue<CreateAccountEvent>(FakeCreateAccountEvent());

    registerFallbackValue<EditProfileState>(FakeEditProfileState());
    registerFallbackValue<EditProfileEvent>(FakeEditProfileEvent());

    registerFallbackValue<ForgotPasswordState>(FakeForgotPasswordState());
    registerFallbackValue<ForgotPasswordEvent>(FakeForgotPasswordEvent());
  });

  await testMain();
}

class FakeEmployeesEvent extends Fake implements EmployeesEvent {}

class FakeInitAppEvent extends Fake implements InitAppEvent {}

class FakeLoginEvent extends Fake implements LoginEvent {}

class FakeUserEvent extends Fake implements UserEvent {}

class FakeCreateAccountEvent extends Fake implements CreateAccountEvent {}

class FakeEditProfileEvent extends Fake implements EditProfileEvent {}

class FakeForgotPasswordEvent extends Fake implements ForgotPasswordEvent {}

class FakeEmployeesState extends Fake implements EmployeesState {}

class FakeInitAppState extends Fake implements InitAppState {}

class FakeLoginState extends Fake implements LoginState {}

class FakeUserState extends Fake implements UserState {}

class FakeCreateAccountState extends Fake implements CreateAccountState {}

class FakeEditProfileState extends Fake implements EditProfileState {}

class FakeForgotPasswordState extends Fake implements ForgotPasswordState {}
