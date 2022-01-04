part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class AppIsFirstTimeLaunched extends AppEvent {
  const AppIsFirstTimeLaunched();
}

class AppUserChanged extends AppEvent {
  const AppUserChanged({required this.user});

  final User user;

  @override
  List<Object> get props => [user];
}

class AppLogoutRequsted extends AppEvent {
  const AppLogoutRequsted();
}
