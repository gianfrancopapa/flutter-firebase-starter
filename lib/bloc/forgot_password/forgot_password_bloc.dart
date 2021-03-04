import 'package:firebasestarter/bloc/forgot_password/forgot_password_event.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_state.dart';
import 'package:firebasestarter/bloc/forms/forgot_password_form.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:get_it/get_it.dart';

class ForgotPasswordBloc extends ForgotPasswordFormBloc {
  AuthService _authService;

  ForgotPasswordBloc() {
    _authService = GetIt.I.get<AuthService>();
  }

  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    switch (event.runtimeType) {
      case ForgotPassword:
        yield* forgotPassword();
        break;
      default:
        yield const Error('Undetermined event');
    }
  }

  Stream<ForgotPasswordState> forgotPassword() async* {
    yield const Loading();
    try {
      await _authService.sendPasswordResetEmail(emailController.value);
      yield const EmailSent();
    } catch (e) {
      yield const Error('Something went wrong');
    }
  }
}
