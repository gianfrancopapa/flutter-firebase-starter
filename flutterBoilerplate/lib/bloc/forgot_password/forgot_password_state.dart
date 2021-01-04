abstract class ForgotPasswordState {
  const ForgotPasswordState();
}

class SendEmail extends ForgotPasswordState {
  const SendEmail();
}

class EmailSended extends ForgotPasswordState {
  const EmailSended();
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
