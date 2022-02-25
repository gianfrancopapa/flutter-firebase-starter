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

class AppDeleteRequested extends AppEvent {
  const AppDeleteRequested();
}

class AppDeleteRequestedSocialMedia extends AppEvent {
  final AuthenticationMethod method;
  const AppDeleteRequestedSocialMedia(this.method);
}

class AppPasswordReauthentication extends AppEvent {
  final String password;
  const AppPasswordReauthentication(this.password);
}
