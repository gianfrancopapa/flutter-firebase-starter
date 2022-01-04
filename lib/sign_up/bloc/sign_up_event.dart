part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class SignUpRequested extends SignUpEvent {
  const SignUpRequested();

  @override
  List<Object> get props => [];
}

class SignUpFirstNameChanged extends SignUpEvent {
  const SignUpFirstNameChanged({required this.firstName});

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

class SignUpLastNameChanged extends SignUpEvent {
  const SignUpLastNameChanged({required this.lastName});

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}

class SignUpPasswordChanged extends SignUpEvent {
  const SignUpPasswordChanged({required this.password});

  final String password;

  @override
  List<Object> get props => [password];
}

class SignUpPasswordConfirmationChanged extends SignUpEvent {
  const SignUpPasswordConfirmationChanged({required this.passwordConfirmation});

  final String passwordConfirmation;

  @override
  List<Object> get props => [passwordConfirmation];
}
