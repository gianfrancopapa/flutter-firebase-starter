import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:firebasestarter/bloc/create_account/create_account_event.dart';
import 'package:firebasestarter/bloc/create_account/create_account_state.dart';
import 'package:firebasestarter/bloc/forms/create_account_form.dart';
import 'package:get_it/get_it.dart';

class CreateAccountBloc extends CreateAccountFormBloc {
  AuthService _authService;
  AnalyticsService _analyticsService;
  static const _errEvent = 'Error: Invalid event in [create_account_bloc.dart]';

  CreateAccountBloc() {
    _authService = GetIt.I.get<AuthService>();
    _analyticsService = GetIt.I.get<AnalyticsService>();
  }

  Stream<CreateAccountState> mapEventToState(CreateAccountEvent event) async* {
    switch (event.runtimeType) {
      case CreateAccount:
        yield* _createAccountWithEmail();
        break;
      default:
        yield const Error(_errEvent);
    }
  }

  Stream<CreateAccountState> _createAccountWithEmail() async* {
    _analyticsService.logSignUp('email');
    yield const Loading();
    try {
      await _authService.createUserWithEmailAndPassword(
        emailVal,
        passwordVal,
      );
      yield const AccountCreated();
    } catch (e) {
      yield Error(e);
    }
  }
}
