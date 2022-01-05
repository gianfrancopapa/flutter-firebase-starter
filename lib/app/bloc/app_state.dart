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
  });

  final AppStatus? status;
  final User? user;

  AppState copyWith({AppStatus? status, User? user}) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, user];
}
