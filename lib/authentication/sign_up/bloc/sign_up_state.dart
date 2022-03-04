part of 'sign_up_bloc.dart';

enum SignUpStatus { initial, success, failure, loading, valid, invalid }

class SignUpState extends Equatable {
  final SignUpStatus status;
  final User? user;
  final FirstName? firstName;
  final LastName? lastName;
  final Email? email;
  final Password? password;
  final Password? passwordConfirmation;

  const SignUpState({
    required this.status,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.user,
  });

  SignUpState.initial()
      : this(
          status: SignUpStatus.initial,
          firstName: FirstName.pure(),
          lastName: LastName.pure(),
          email: Email.pure(),
          password: Password.pure(),
          passwordConfirmation: Password.pure(),
        );

  SignUpState copyWith({
    SignUpStatus? status,
    User? user,
    FirstName? firstName,
    LastName? lastName,
    Email? email,
    Password? password,
    Password? passwordConfirmation,
  }) {
    return SignUpState(
      status: status ?? this.status,
      user: user ?? this.user,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        firstName,
        lastName,
        email,
        password,
        passwordConfirmation,
      ];
}
