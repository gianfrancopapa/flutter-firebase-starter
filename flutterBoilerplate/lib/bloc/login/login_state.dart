abstract class LoginState {
  const LoginState();
}

class LoggedIn extends LoginState {
  const LoggedIn();
}

class LoggedOut extends LoginState {
  const LoggedOut();
}

class NotDetermined extends LoginState {
  const NotDetermined();
}

class ErrorLogin extends LoginState {
  final String message;
  const ErrorLogin(this.message);
}

class Loading extends LoginState {
  const Loading();
}
