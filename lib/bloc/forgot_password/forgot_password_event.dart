import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class PasswordReset extends ForgotPasswordEvent {
  final emailAddress;
  const PasswordReset(String this.emailAddress);
}

class EmailAddressUpdated extends ForgotPasswordEvent {
  final emailAddress;
  const EmailAddressUpdated({this.emailAddress});

  @override
  List<Object> get props => [emailAddress];
}
