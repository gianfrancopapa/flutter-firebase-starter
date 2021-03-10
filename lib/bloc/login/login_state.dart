import 'package:firebasestarter/models/user.dart';

abstract class LoginState {
  const LoginState();
}

class LoginSuccess extends LoginState {
  final User currentUser;
  const LoginSuccess(this.currentUser);
}

class LogoutSuccess extends LoginState {
  const LogoutSuccess();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure(this.message);
}

class LoginInProgress extends LoginState {
  const LoginInProgress();
}
