part of 'verifiy_email_bloc.dart';

enum VerifyEmailStatus { loading, success, error, verified }

class VerifiyEmailState extends Equatable {
  const VerifiyEmailState({
    this.status,
  });

  final VerifyEmailStatus? status;

  VerifiyEmailState copyWith({VerifyEmailStatus? status}) {
    return VerifiyEmailState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}
