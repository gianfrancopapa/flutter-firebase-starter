import 'package:equatable/equatable.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({@required AuthService authService})
      : assert(authService != null),
        _authService = authService,
        super(SignUpState.initial());

  final AuthService _authService;

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpRequested) {
      yield* _mapSignUpRequestedToState(event);
    } else if (event is SignUpFirstNameChanged) {
      yield* _mapSignUpFirstNameChangedToState(event);
    } else if (event is SignUpLastNameChanged) {
      yield* _mapSignUpLastNameChangedToState(event);
    } else if (event is SignUpEmailChanged) {
      yield* _mapSignUpEmailChangedToState(event);
    } else if (event is SignUpPasswordChanged) {
      yield* _mapSignUpPasswordChangedToState(event);
    } else if (event is SignUpPasswordConfirmationChanged) {
      yield* _mapSignUpPasswordConfirmationChangedToState(event);
    }
  }

  Stream<SignUpState> _mapSignUpRequestedToState(
    SignUpRequested event,
  ) async* {
    yield state.copyWith(status: SignUpStatus.loading);

    if (state.password.value != state.passwordConfirmation.value) {
      yield state.copyWith(status: SignUpStatus.failure);
      return;
    }

    try {
      final user = await _authService.createUserWithEmailAndPassword(
        name: state.firstName.value,
        lastName: state.lastName.value,
        email: state.email.value,
        password: state.password.value,
      );

      yield state.copyWith(status: SignUpStatus.success, user: user);
    } catch (error) {
      yield state.copyWith(status: SignUpStatus.failure);
    }
  }

  Stream<SignUpState> _mapSignUpFirstNameChangedToState(
    SignUpFirstNameChanged event,
  ) async* {
    final firstName = FirstName.dirty(event.firstName);

    yield state.copyWith(
      firstName: firstName,
      status: _status(firstName: firstName),
    );
  }

  Stream<SignUpState> _mapSignUpLastNameChangedToState(
    SignUpLastNameChanged event,
  ) async* {
    final lastName = LastName.dirty(event.lastName);

    yield state.copyWith(
      lastName: lastName,
      status: _status(lastName: lastName),
    );
  }

  Stream<SignUpState> _mapSignUpEmailChangedToState(
    SignUpEmailChanged event,
  ) async* {
    final email = Email.dirty(event.email);

    yield state.copyWith(email: email, status: _status(email: email));
  }

  Stream<SignUpState> _mapSignUpPasswordChangedToState(
    SignUpPasswordChanged event,
  ) async* {
    final password = Password.dirty(event.password);

    yield state.copyWith(
      password: password,
      status: _status(password: password),
    );
  }

  Stream<SignUpState> _mapSignUpPasswordConfirmationChangedToState(
    SignUpPasswordConfirmationChanged event,
  ) async* {
    final passwordConfirmation = Password.dirty(event.passwordConfirmation);

    yield state.copyWith(
      passwordConfirmation: passwordConfirmation,
      status: _status(passwordConfirmation: passwordConfirmation),
    );
  }

  SignUpStatus _status({
    FirstName firstName,
    LastName lastName,
    Email email,
    Password password,
    Password passwordConfirmation,
  }) {
    final _firstName = firstName ?? state.firstName;
    final _lastName = lastName ?? state.lastName;
    final _email = email ?? state.email;
    final _password = password ?? state.password;
    final _passwordConf = passwordConfirmation ?? state.passwordConfirmation;

    if (_firstName.valid &&
        _lastName.valid &&
        _email.valid &&
        _password.valid &&
        _passwordConf.valid) {
      return SignUpStatus.valid;
    }

    return SignUpStatus.invalid;
  }
}
