part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class ForgotPasswordResetRequested extends ForgotPasswordEvent {
  const ForgotPasswordResetRequested();
}

class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  const ForgotPasswordEmailChanged({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}
