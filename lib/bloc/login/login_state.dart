import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/user.dart';

enum LoginStatus { initial, inProgress, loginSuccess, logoutSuccess, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final User currentUser;
  final String errorMessage;

  const LoginState({
    LoginStatus this.status = LoginStatus.initial,
    User this.currentUser,
    String this.errorMessage,
  }) : assert(status != null);

  LoginState copyWith({
    LoginStatus status,
    User currentUser,
    String errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
        currentUser,
        errorMessage,
      ];
}
