part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  loading,
  loggedIn,
  loggedOut,
  failure,
  valid,
  invalid,
  passwordlessValid,
}

class LoginState extends Equatable {
  final LoginStatus status;
  final AuthError error;
  final User user;
  final Email email;
  final Email passwordlessEmail;
  final Password password;

  const LoginState({
    @required this.status,
    this.error,
    this.user,
    this.email,
    this.passwordlessEmail,
    this.password,
  }) : assert(status != null);

  LoginState.initial()
      : this(
          status: LoginStatus.initial,
          email: Email.pure(),
          passwordlessEmail: Email.pure(),
          password: Password.pure(),
        );

  LoginState copyWith({
    LoginStatus status,
    AuthError error,
    User user,
    Email email,
    Email passwordlessEmail,
    Password password,
  }) {
    return LoginState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      email: email ?? this.email,
      passwordlessEmail: passwordlessEmail ?? this.passwordlessEmail,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [status, error, user, email, passwordlessEmail, password];
}
