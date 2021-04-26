import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/bloc/create_account/create_account_event.dart';
import 'package:firebasestarter/bloc/create_account/create_account_state.dart';
import 'package:firebasestarter/bloc/forms/create_account_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  static const _errEvent = 'Error: Invalid event in [create_account_bloc.dart]';
  static const _errPasswordMismatch = 'Error: Passwords doesn\'t match.';
  AuthService _firebaseAuth;
  final form = CreateAccountFormBloc();

  CreateAccountBloc() : super(const CreateAccountInitial()) {
    _firebaseAuth = GetIt.I<AuthService>();
  }

  @override
  Stream<CreateAccountState> mapEventToState(CreateAccountEvent event) async* {
    switch (event.runtimeType) {
      case AccountCreated:
        yield* _mapAccountCreatedToState();
        break;
      default:
        yield const CreateAccountFailure(_errEvent);
    }
  }

  Stream<CreateAccountState> _mapAccountCreatedToState() async* {
    yield const CreateAccountInProgress();
    if (form.passwordConfVal != form.passwordVal) {
      yield const CreateAccountFailure(_errPasswordMismatch);
      return;
    }
    try {
      final user = await _firebaseAuth.createUserWithEmailAndPassword(
        name: form.firstNameVal,
        lastName: form.lastNameVal,
        email: form.emailVal,
        password: form.passwordVal,
      );
      yield CreateAccountSuccess(user);
    } catch (e) {
      yield CreateAccountFailure(e);
    }
  }
}
