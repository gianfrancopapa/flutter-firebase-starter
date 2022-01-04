part of 'forgot_password_bloc.dart';

enum ForgotPasswordStatus { initial, loading, success, failure, valid, invalid }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStatus status;
  final Email? email;

  const ForgotPasswordState({
    required this.status,
    this.email,
  });

  ForgotPasswordState.initial()
      : this(
          status: ForgotPasswordStatus.initial,
          email: Email.pure(),
        );

  ForgotPasswordState copyWith({ForgotPasswordStatus? status, Email? email}) {
    return ForgotPasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [status, email];
}
