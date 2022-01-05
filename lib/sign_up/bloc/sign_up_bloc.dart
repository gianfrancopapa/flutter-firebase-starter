import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({required AuthService authService})
      : _authService = authService,
        super(SignUpState.initial()) {
    on<SignUpRequested>(_mapSignUpRequestedToState);
    on<SignUpFirstNameChanged>(_mapSignUpFirstNameChangedToState);
    on<SignUpLastNameChanged>(_mapSignUpLastNameChangedToState);
    on<SignUpEmailChanged>(_mapSignUpEmailChangedToState);
    on<SignUpPasswordChanged>(_mapSignUpPasswordChangedToState);
    on<SignUpPasswordConfirmationChanged>(
        _mapSignUpPasswordConfirmationChangedToState);
  }

  final AuthService _authService;

  Future<void> _mapSignUpRequestedToState(
    SignUpRequested event,
    Emitter<SignUpState> emit,
  ) async {
    emit(state.copyWith(status: SignUpStatus.loading));

    if (state.password!.value != state.passwordConfirmation!.value) {
      emit(state.copyWith(status: SignUpStatus.failure));
      return;
    }

    try {
      final user = await (_authService.createUserWithEmailAndPassword(
        name: state.firstName!.value!,
        lastName: state.lastName!.value!,
        email: state.email!.value!,
        password: state.password!.value!,
      ));

      emit(state.copyWith(status: SignUpStatus.success, user: _toUser(user!)));
    } catch (error) {
      emit(state.copyWith(status: SignUpStatus.failure));
    }
  }

  Future<void> _mapSignUpFirstNameChangedToState(
    SignUpFirstNameChanged event,
    Emitter<SignUpState> emit,
  ) async {
    final firstName = FirstName.dirty(event.firstName);

    emit(state.copyWith(
      firstName: firstName,
      status: _status(firstName: firstName),
    ));
  }

  Future<void> _mapSignUpLastNameChangedToState(
    SignUpLastNameChanged event,
    Emitter<SignUpState> emit,
  ) async {
    final lastName = LastName.dirty(event.lastName);

    emit(state.copyWith(
      lastName: lastName,
      status: _status(lastName: lastName),
    ));
  }

  Future<void> _mapSignUpEmailChangedToState(
    SignUpEmailChanged event,
    Emitter<SignUpState> emit,
  ) async {
    final email = Email.dirty(event.email);

    emit(state.copyWith(email: email, status: _status(email: email)));
  }

  Future<void> _mapSignUpPasswordChangedToState(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) async {
    final password = Password.dirty(event.password);

    emit(state.copyWith(
      password: password,
      status: _status(password: password),
    ));
  }

  Future<void> _mapSignUpPasswordConfirmationChangedToState(
    SignUpPasswordConfirmationChanged event,
    Emitter<SignUpState> emit,
  ) async {
    final passwordConfirmation = Password.dirty(event.passwordConfirmation);

    emit(state.copyWith(
      passwordConfirmation: passwordConfirmation,
      status: _status(passwordConfirmation: passwordConfirmation),
    ));
  }

  SignUpStatus _status({
    FirstName? firstName,
    LastName? lastName,
    Email? email,
    Password? password,
    Password? passwordConfirmation,
  }) {
    final _firstName = firstName ?? state.firstName!;
    final _lastName = lastName ?? state.lastName;
    final _email = email ?? state.email;
    final _password = password ?? state.password;
    final _passwordConf = passwordConfirmation ?? state.passwordConfirmation;

    if (_firstName.valid &&
        _lastName!.valid &&
        _email!.valid &&
        _password!.valid &&
        _passwordConf!.valid) {
      return SignUpStatus.valid;
    }

    return SignUpStatus.invalid;
  }

  User _toUser(UserEntity entity) => User.fromEntity(entity);
}
