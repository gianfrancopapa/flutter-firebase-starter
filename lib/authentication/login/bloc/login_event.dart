part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginWithEmailAndPasswordRequested extends LoginEvent {
  const LoginWithEmailAndPasswordRequested();
}

class LoginWithSocialMediaRequested extends LoginEvent {
  const LoginWithSocialMediaRequested({required this.method});

  final AuthenticationMethod method;
}

class LoginAnonymouslyRequested extends LoginEvent {
  const LoginAnonymouslyRequested();
}

class LoginIsSessionPersisted extends LoginEvent {
  const LoginIsSessionPersisted();
}

class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class LoginPasswordlessEmailChanged extends LoginEvent {
  const LoginPasswordlessEmailChanged({required this.passwordlessEmail});
  final String passwordlessEmail;

  @override
  List<Object> get props => [passwordlessEmail];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginPasswordlessRequested extends LoginEvent {
  const LoginPasswordlessRequested({required this.uri});
  final Uri uri;

  @override
  List<Object> get props => [uri];
}

class LoginSendEmailRequested extends LoginEvent {
  const LoginSendEmailRequested();
}
