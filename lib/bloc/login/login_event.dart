import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginStarted extends LoginEvent {
  const LoginStarted();
}

class GoogleLoginStarted extends LoginEvent {
  const GoogleLoginStarted();
}

class AppleLoginStarted extends LoginEvent {
  const AppleLoginStarted();
}

class FacebookLoginStarted extends LoginEvent {
  const FacebookLoginStarted();
}

class AnonymousLoginStarted extends LoginEvent {
  const AnonymousLoginStarted();
}

class LogoutStarted extends LoginEvent {
  const LogoutStarted();
}

class IsUserLoggedIn extends LoginEvent {
  const IsUserLoggedIn();
}

class EmailAddressUpdated extends LoginEvent {
  final String emailAddress;
  const EmailAddressUpdated({this.emailAddress});

  @override
  List<Object> get props => [emailAddress];
}

class PasswordUpdated extends LoginEvent {
  final String password;
  const PasswordUpdated({this.password});

  @override
  List<Object> get props => [password];
}
