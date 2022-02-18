part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  loading,
  loggedIn,
  loggedOut,
  failure,
  valid,
  invalid,
}

class LoginState extends Equatable {
  final LoginStatus status;
  final AuthError? error;
  final User? user;
  final Email? email;
  final Password? password;
  final SocialMediaMethod? method;

  const LoginState({
    required this.status,
    this.error,
    this.user,
    this.email,
    this.password,
    this.method,
  });

  LoginState.initial()
      : this(
          status: LoginStatus.initial,
          email: Email.pure(),
          password: Password.pure(),
        );

  LoginState copyWith({
    LoginStatus? status,
    AuthError? error,
    User? user,
    Email? email,
    Password? password,
    SocialMediaMethod? method,
  }) {
    return LoginState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      email: email ?? this.email,
      password: password ?? this.password,
      method: method,
    );
  }

  @override
  List<Object?> get props => [status, error, user, email, password, method];
}
