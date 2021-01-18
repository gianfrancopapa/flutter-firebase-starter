abstract class ForgotPasswordState {
  const ForgotPasswordState();
}

class EmailSent extends ForgotPasswordState {
  const EmailSent();
}

class NotDetermined extends ForgotPasswordState {
  const NotDetermined();
}

class Error extends ForgotPasswordState {
  final String message;
  const Error(this.message);
}

class Loading extends ForgotPasswordState {
  const Loading();
}
