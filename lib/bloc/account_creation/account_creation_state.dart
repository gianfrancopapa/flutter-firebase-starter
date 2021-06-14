import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/user.dart';

enum AccountCreationStatus { initial, success, failure, inProgress }

class AccountCreationState extends Equatable {
  final AccountCreationStatus status;
  final User user;
  final String errorMessage;

  const AccountCreationState({
    this.status = AccountCreationStatus.initial,
    this.user,
    this.errorMessage,
  }) : assert(status != null);

  AccountCreationState copyWith({
    AccountCreationStatus status,
    User user,
    String errorMessage,
  }) {
    return AccountCreationState(
        status: status ?? this.status,
        user: user ?? this.user,
        errorMessage: errorMessage ?? errorMessage);
  }

  @override
  List<Object> get props => [status, user, errorMessage];
}
