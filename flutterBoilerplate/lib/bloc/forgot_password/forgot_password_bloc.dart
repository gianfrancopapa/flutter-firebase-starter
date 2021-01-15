import 'package:flutterBoilerplate/bloc/forgot_password/forgot_password_event.dart';
import 'package:flutterBoilerplate/bloc/forgot_password/forgot_password_state.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';
import 'package:flutterBoilerplate/bloc/forms/forgot_password_form.dart';

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
      await _firebaseAuth.forgotPassword(emailController.value);
      yield const EmailSended();
    } catch (e) {
      yield const Error('Something went wrong');
    }
  }
}
