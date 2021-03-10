abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class PasswordReset extends ForgotPasswordEvent {
  const PasswordReset();
}
