part of 'user_bloc.dart';

enum UserStatus { initial, loading, success, failure }

class UserState extends Equatable {
  const UserState({required this.status, this.user});

  final UserStatus status;
  final User? user;

  UserState copyWith({UserStatus? status, User? user}) {
    return UserState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, user];
}
