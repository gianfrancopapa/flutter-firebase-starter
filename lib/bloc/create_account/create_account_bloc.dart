import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';
import 'package:firebasestarter/bloc/create_account/create_account_event.dart';
import 'package:firebasestarter/bloc/create_account/create_account_state.dart';
import 'package:firebasestarter/bloc/forms/create_account_form.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  static const _errEvent = 'Error: Invalid event in [create_account_bloc.dart]';
  static const _errPasswordMismatch = 'Error: Passwords doesn\'t match.';
  final _firebaseAuth = FirebaseAuthService();
  final form = CreateAccountFormBloc();

  CreateAccountBloc() : super(const NotDetermined());

  @override
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
    GetIt.I.get<AnalyticsService>().logSignUp('email');
    yield const Loading();
    if (form.passwordConfVal != form.passwordVal) {
      yield const Error(_errPasswordMismatch);
      return;
    }
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        form.emailVal,
        form.passwordVal,
      );
      yield const AccountCreated();
    } catch (e) {
      yield Error(e);
    }
  }
}
