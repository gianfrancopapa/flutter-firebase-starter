import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
<<<<<<< HEAD
=======
import 'package:firebasestarter/services/shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
>>>>>>> 68e59ef87e88ec7055f93ae665d68170246b6772
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthService authService,
    required AnalyticsService analyticsService,
  })  : _authService = authService,
        _analyticsService = analyticsService,
        super(LoginState.initial()) {
    on<LoginWithEmailAndPasswordRequested>(
        _mapLoginWithEmailAndPasswordRequestedToState);
    on<LoginWithSocialMediaRequested>(_mapLoginWithSocialMediaRequestedToState);
    on<LoginAnonymouslyRequested>(_mapLoginAnonymouslyRequestedToState);
    on<LoginIsSessionPersisted>(_mapLoginIsSessionPersistedToState);
    on<LoginEmailChanged>(_mapLoginEmailChangedToState);
    on<LoginPasswordChanged>(_mapLoginPasswordChangedToState);
  }

  final AuthService _authService;
  final AnalyticsService _analyticsService;
  final passwordlessEmailKey = 'passwordlessEmail';

<<<<<<< HEAD
  Future<void> _mapLoginWithEmailAndPasswordRequestedToState(
    LoginWithEmailAndPasswordRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
=======
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithEmailAndPasswordRequested) {
      yield* _mapLoginWithEmailAndPasswordRequestedToState();
    } else if (event is LoginWithSocialMediaRequested) {
      yield* _mapLoginWithSocialMediaRequestedToState(event);
    } else if (event is LoginAnonymouslyRequested) {
      yield* _mapLoginAnonymouslyRequestedToState();
    } else if (event is LoginIsSessionPersisted) {
      yield* _mapLoginIsSessionPersistedToState();
    } else if (event is LoginEmailChanged) {
      yield* _mapLoginEmailChangedToState(event);
    } else if (event is LoginPasswordlessEmailChanged) {
      yield* _mapLoginPasswordlessEmailChangedToState(event);
    } else if (event is LoginPasswordChanged) {
      yield* _mapLoginPasswordChangedToState(event);
    } else if (event is LoginPasswordlessRequested) {
      yield* _mapLoginPasswordlessRequestedToState(event);
    } else if (event is LoginSendEmailRequested) {
      yield* _mapLoginSendEmailToState(event);
    }
  }

  Stream<LoginState> _mapLoginWithEmailAndPasswordRequestedToState() async* {
    yield state.copyWith(status: LoginStatus.loading);

>>>>>>> 68e59ef87e88ec7055f93ae665d68170246b6772
    try {
      final user = await _authService.signInWithEmailAndPassword(
        email: state.email!.value!,
        password: state.password!.value!,
      );
      emit(state.copyWith(status: LoginStatus.loggedIn, user: _toUser(user!)));
    } on AuthError catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, error: e));
    }
  }

  Future<void> _mapLoginWithSocialMediaRequestedToState(
    LoginWithSocialMediaRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    _analyticsService.logLogin(event.toString());

    try {
      final user = await _authService.signInWithSocialMedia(method: event.method);

      if (user != null) {
        emit(state.copyWith(status: LoginStatus.loggedIn, user: _toUser(user)));
      } else {
        emit(state.copyWith(status: LoginStatus.loggedOut));
      }
    } on AuthError catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, error: e));
    }
  }

  Future<void> _mapLoginAnonymouslyRequestedToState(
    LoginAnonymouslyRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final user = await _authService.signInAnonymously();

      emit(state.copyWith(status: LoginStatus.loggedIn, user: _toUser(user!)));
    } on AuthError catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, error: e));
    }
  }

  Future<void> _mapLoginIsSessionPersistedToState(
    LoginIsSessionPersisted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final user = await _authService.currentUser();

      if (user != null) {
        emit(state.copyWith(status: LoginStatus.loggedIn, user: _toUser(user)));
        return;
      }

      emit(state.copyWith(status: LoginStatus.loggedOut));
    } on AuthError catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, error: e));
    }
  }

  Future<void> _mapLoginEmailChangedToState(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) async {
    final email = Email.dirty(event.email);

    emit(state.copyWith(
      email: email,
      status: _status(email: email),
    ));
  }

<<<<<<< HEAD
  Future<void> _mapLoginPasswordChangedToState(
=======
  Stream<LoginState> _mapLoginPasswordlessEmailChangedToState(
    LoginPasswordlessEmailChanged event,
  ) async* {
    final passwordlessEmail = Email.dirty(event.passwordlessEmail);

    yield state.copyWith(
      passwordlessEmail: passwordlessEmail,
      status: _passwordlessStatus(passwordlessEmail: passwordlessEmail),
    );
  }

  Stream<LoginState> _mapLoginPasswordChangedToState(
>>>>>>> 68e59ef87e88ec7055f93ae665d68170246b6772
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    final password = Password.dirty(event.password);

    emit(state.copyWith(
      password: password,
      status: _status(password: password),
    ));
  }

<<<<<<< HEAD
  LoginStatus _status({Email? email, Password? password}) {
    final _email = email ?? state.email!;
=======
  Stream<LoginState> _mapLoginSendEmailToState(LoginSendEmailRequested event) async* {
    try {
      await MySharedPreferences().setValue(passwordlessEmailKey, event.passwordlessEmail);
      await _authService.sendSignInLinkToEmail(email: event.passwordlessEmail);

      yield state.copyWith(status: LoginStatus.initial);
    } on AuthError catch (e) {
      yield state.copyWith(status: LoginStatus.failure, error: e);
    }
  }

  Stream<LoginState> _mapLoginPasswordlessRequestedToState(LoginPasswordlessRequested event) async* {
    yield state.copyWith(status: LoginStatus.loading);

    try {
      if (_authService.isSignInWithEmailLink(emailLink: event.uri.toString())) {
        final email = await MySharedPreferences().getValue<String>('passwordlessEmail');
        final user = await _authService.signInWithEmailLink(email: email, emailLink: event.uri.toString());

        yield state.copyWith(status: LoginStatus.loggedIn, user: _toUser(user));
      }
    } on AuthError catch (e) {
      yield state.copyWith(status: LoginStatus.failure, error: e);
    }
  }

  LoginStatus _status({Email email, Password password}) {
    final _email = email ?? state.email;
>>>>>>> 68e59ef87e88ec7055f93ae665d68170246b6772
    final _password = password ?? state.password;

    if (_email.valid && _password!.valid) return LoginStatus.valid;

    return LoginStatus.invalid;
  }

  LoginStatus _passwordlessStatus({Email passwordlessEmail}) {
    final _passwordlessEmail = passwordlessEmail ?? state.passwordlessEmail;

    if (_passwordlessEmail.valid) return LoginStatus.passwordlessValid;

    return LoginStatus.invalid;
  }

  User _toUser(UserEntity entity) => User.fromEntity(entity);
}
