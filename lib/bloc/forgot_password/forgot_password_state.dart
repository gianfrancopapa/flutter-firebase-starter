import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus { initial, inProgress, emailSent, failure }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStatus status;
  final String errorMessage;
  final String emailAddress;

  const ForgotPasswordState(
      {ForgotPasswordStatus this.status = ForgotPasswordStatus.initial,
      String this.errorMessage,
      String this.emailAddress})
      : assert(status != null);

  ForgotPasswordState copyWith(
      {ForgotPasswordStatus status, String errorMessage, String emailAddress}) {
    return ForgotPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      emailAddress: emailAddress ?? this.emailAddress,
    );
  }

  @override
  List<Object> get props => [status, errorMessage, emailAddress];
}
