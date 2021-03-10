abstract class ForgotPasswordState {
  const ForgotPasswordState();
}

class ForgotPasswordEmailSent extends ForgotPasswordState {
  const ForgotPasswordEmailSent();
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;
  const ForgotPasswordFailure(this.message);
}

class ForgotPasswordInProgress extends ForgotPasswordState {
  const ForgotPasswordInProgress();
}
