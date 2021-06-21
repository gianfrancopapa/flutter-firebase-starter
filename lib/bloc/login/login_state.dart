import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/user.dart';

enum LoginStatus { initial, inProgress, loginSuccess, logoutSuccess, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final User currentUser;
  final String errorMessage;
  final String emailAddress;
  final String password;

  const LoginState({
    LoginStatus this.status = LoginStatus.initial,
    User this.currentUser,
    String this.errorMessage,
    String this.emailAddress,
    String this.password,
  }) : assert(status != null);

  LoginState copyWith({
    LoginStatus status,
    User currentUser,
    String errorMessage,
    String emailAddress,
    String password,
  }) {
    return LoginState(
      status: status ?? this.status,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: errorMessage ?? this.errorMessage,
      emailAddress: emailAddress ?? this.emailAddress,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [
        status,
        currentUser,
        errorMessage,
        emailAddress,
        password,
      ];
}
