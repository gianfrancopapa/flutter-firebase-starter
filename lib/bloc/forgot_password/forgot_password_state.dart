import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus { initial, inProgress, emailSent, failure }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStatus status;
  final String errorMessage;

  const ForgotPasswordState({
    ForgotPasswordStatus this.status = ForgotPasswordStatus.initial,
    String this.errorMessage,
  }) : assert(status != null);

  ForgotPasswordState copyWith(
      {ForgotPasswordStatus status, String errorMessage}) {
    return ForgotPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, errorMessage];
}
