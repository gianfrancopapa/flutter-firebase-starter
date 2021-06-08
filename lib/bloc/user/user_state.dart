import 'package:firebasestarter/models/user.dart';
import 'package:equatable/equatable.dart';

enum UserStatus { initial, inProgress, success, failure }

class UserState extends Equatable {
  final UserStatus status;
  final User user;
  final String errorMessage;

  const UserState({
    UserStatus this.status = UserStatus.initial,
    User this.user,
    String this.errorMessage,
  }) : assert(status != null);

  UserState copyWith({UserStatus status, User user, String errorMessage}) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, user, errorMessage];
}
