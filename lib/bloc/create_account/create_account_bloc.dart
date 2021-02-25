import 'package:flutter/foundation.dart';
import 'package:flutterBoilerplate/bloc/create_account/create_account_event.dart';
import 'package:flutterBoilerplate/bloc/create_account/create_account_state.dart';
import 'package:flutterBoilerplate/bloc/forms/create_account_form.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';

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
    yield const Loading();
    if (passwordConfirmationController.value != passwordController.value) {
      yield const Error('Error: Passwords doesn\'t match.');
      return;
    }
    try {
      await _firebaseAuth.createAccountWithEmail(
        firstName: firstNameController.value,
        lastName: lastNameController.value,
        email: emailController.value,
        password: passwordController.value,
      );
      yield const AccountCreated();
    } catch (e) {
      yield Error(e);
    }
  }
}
