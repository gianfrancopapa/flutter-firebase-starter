import 'package:firebasestarter/bloc/account_creation/account_creation_event.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_state.dart';
import 'package:firebasestarter/bloc/forms/create_account_form.dart';
import 'package:firebasestarter/services/auth/user_mapper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:somnio_firebase_authentication/src/auth_service.dart';

class AccountCreationBloc
    extends Bloc<AccountCreationEvent, AccountCreationState> {
  static const _errPasswordMismatch = 'Error: Passwords doesn\'t match.';

  AuthService _firebaseAuth;
  CreateAccountFormBloc form;

  AccountCreationBloc({
    AuthService authService,
    CreateAccountFormBloc form,
  }) : super(const AccountCreationState()) {
    _firebaseAuth = authService ?? GetIt.I<AuthService>();
    this.form = form ?? CreateAccountFormBloc();
  }

  @override
  Stream<AccountCreationState> mapEventToState(
      AccountCreationEvent event) async* {
    if (event is AccountCreationRequested) {
      yield* _mapAccountCreationRequestedToState(event, state);
    }
  }

  Stream<AccountCreationState> _mapAccountCreationRequestedToState(
      AccountCreationEvent event, AccountCreationState state) async* {
    yield state.copyWith(
      status: AccountCreationStatus.inProgress,
    );
    if (form.passwordConfVal != form.passwordVal) {
      yield state.copyWith(
        status: AccountCreationStatus.failure,
        errorMessage: _errPasswordMismatch,
      );
      return;
    }
    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(
        name: form.firstNameVal,
        lastName: form.lastNameVal,
        email: form.emailVal,
        password: form.passwordVal,
      );
      yield state.copyWith(
        status: AccountCreationStatus.success,
        user: mapFirebaseUser(user),
      );
    } catch (error) {
      yield state.copyWith(
        status: AccountCreationStatus.failure,
        errorMessage: error.message,
      );
    }
  }
}
