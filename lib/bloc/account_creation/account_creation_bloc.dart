import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_event.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_state.dart';
import 'package:firebasestarter/bloc/forms/create_account_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AccountCreationBloc
    extends Bloc<AccountCreationEvent, AccountCreationState> {
  static const _errEvent = 'Error: Invalid event in [create_account_bloc.dart]';
  static const _errPasswordMismatch = 'Error: Passwords doesn\'t match.';

  AuthService _firebaseAuth;
  final form = CreateAccountFormBloc();

  AccountCreationBloc() : super(const AccountCreationState()) {
    _firebaseAuth = GetIt.I<AuthService>();
  }

  @override
  Stream<AccountCreationState> mapEventToState(
      AccountCreationEvent event) async* {
    if (event is AccountCreationRequested) {
      yield* _mapAccountCreationRequestedToState(event, state);
    } else {
      yield state.copyWith(
        status: AccountCreationStatus.failure,
        errorMessage: _errEvent,
      );
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
        user: user,
      );
    } catch (error) {
      yield state.copyWith(
        status: AccountCreationStatus.failure,
        errorMessage: error.message,
      );
    }
  }
}
