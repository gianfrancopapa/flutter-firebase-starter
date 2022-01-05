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

  final SocialMediaMethod method;
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

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}
