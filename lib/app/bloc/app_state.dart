part of 'app_bloc.dart';

enum AppStatus {
  initial,
  firstTime,
  authenticated,
  unauthenticated,
  failure,
}

class AppState extends Equatable {
  const AppState({
    required this.status,
    this.user,
    this.password,
  });

  final AppStatus? status;
  final User? user;
  final String? password;

  AppState copyWith({AppStatus? status, User? user, String? password}) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [status, user, password];
}
