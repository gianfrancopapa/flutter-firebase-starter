part of 'delete_account_bloc.dart';

enum DeleteAccountStatus { initial, loading, success, failure, valid, invalid }

class DeleteAccountState extends Equatable {
  const DeleteAccountState({
    this.user,
    this.password,
    this.status,
  });

  final User? user;
  final String? password;
  final DeleteAccountStatus? status;

  DeleteAccountState copyWith(
      {User? user, String? password, DeleteAccountStatus? status}) {
    return DeleteAccountState(
      user: user ?? this.user,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [user, password];
}

class DeleteAccountInitial extends DeleteAccountState {}
