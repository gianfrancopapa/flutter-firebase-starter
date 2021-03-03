import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:firebasestarter/bloc/create_account/create_account_event.dart';
import 'package:firebasestarter/bloc/create_account/create_account_state.dart';
import 'package:firebasestarter/bloc/forms/create_account_form.dart';
import 'package:get_it/get_it.dart';

class CreateAccountBloc extends CreateAccountFormBloc {
  final _firebaseAuth = FirebaseAuthService();

  @override
  Stream<CreateAccountState> mapEventToState(CreateAccountEvent event) async* {
    switch (event.runtimeType) {
      case CreateAccount:
        yield* createAccountWithEmail();
        break;
      default:
        yield const Error('Invalid event.');
    }
  }

  @protected
  @override
  Stream<CreateAccountState> createAccountWithEmail() async* {
    GetIt.I.get<AnalyticsService>().logSignUp('email');
    yield const Loading();
    if (passwordConfirmationController.value != passwordController.value) {
      yield const Error('Error: Passwords doesn\'t match.');
      return;
    }
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        emailController.value,
        passwordController.value,
      );
      yield const AccountCreated();
    } catch (e) {
      yield Error(e);
    }
  }
}
