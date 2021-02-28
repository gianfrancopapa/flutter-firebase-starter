import 'package:firebasestarter/bloc/forgot_password/forgot_password_event.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_state.dart';
import 'package:firebasestarter/bloc/forms/forgot_password_form.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';

class ForgotPasswordBloc extends ForgotPasswordFormBloc {
  final _firebaseAuth = FirebaseAuthService();

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
      await _firebaseAuth.sendPasswordResetEmail(emailController.value);
      yield const EmailSent();
    } catch (e) {
      yield const Error('Something went wrong');
    }
  }
}
