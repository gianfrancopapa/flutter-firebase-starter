import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/shared_preferences/shared_preferences.dart';
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
    on<LoginPasswordlessRequested>(_mapLoginPasswordlessRequestedToState);
    on<LoginSendEmailRequested>(_mapLoginSendEmailToState);
    on<LoginPasswordlessEmailChanged>(_mapLoginPasswordlessEmailChangedToState);
  }

  final AuthService _authService;
  final AnalyticsService _analyticsService;
  final passwordlessEmailKey = 'passwordlessEmail';

  Future<void> _mapLoginWithEmailAndPasswordRequestedToState(
    LoginWithEmailAndPasswordRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final user = await _authService.signInWithEmailAndPassword(
        email: state.email!.value!,
        password: state.password!.value!,
      );
      emit(state.copyWith(
          status: LoginStatus.loggedIn, user: _toUser(user!), method: null));
    } on AuthError catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, error: e));
    }
  }

  Future<void> _mapLoginWithSocialMediaRequestedToState(
    LoginWithSocialMediaRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, method: event.method));
    _analyticsService.logLogin(event.toString());

    try {
      final user =
          await _authService.signInWithSocialMedia(method: event.method);

      if (user != null) {
        emit(state.copyWith(
            status: LoginStatus.loggedIn,
            user: _toUser(user),
            method: event.method));
      } else {
        emit(state.copyWith(status: LoginStatus.loggedOut, method: null));
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

  Future<void> _mapLoginPasswordChangedToState(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    final password = Password.dirty(event.password);

    emit(state.copyWith(
      password: password,
      status: _status(password: password),
    ));
  }

  Future<void> _mapLoginPasswordlessEmailChangedToState(
      LoginPasswordlessEmailChanged event, Emitter emit) async {
    final passwordlessEmail = Email.dirty(event.passwordlessEmail);

    emit(state.copyWith(
      passwordlessEmail: passwordlessEmail,
      status: _passwordlessStatus(passwordlessEmail: passwordlessEmail),
    ));
  }

  Future<void> _mapLoginSendEmailToState(
      LoginSendEmailRequested event, Emitter emit) async {
    try {
      final email = state.passwordlessEmail!.value!;
      await MySharedPreferences()
          .setValue(passwordlessEmailKey, state.passwordlessEmail!.value!);
      await _authService.sendSignInLinkToEmail(email: email);
      emit(state.copyWith(status: LoginStatus.initial));
    } on AuthError catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, error: e));
    }
  }

  Future<void> _mapLoginPasswordlessRequestedToState(
      LoginPasswordlessRequested event, Emitter emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      if (_authService.isSignInWithEmailLink(emailLink: event.uri.toString())) {
        final email =
            await MySharedPreferences().getValue<String>('passwordlessEmail');
        final user = await _authService.signInWithEmailLink(
            email: email, emailLink: event.uri.toString());

        emit(
            state.copyWith(status: LoginStatus.loggedIn, user: _toUser(user!)));
      }
    } on AuthError catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, error: e));
    }
  }

  LoginStatus _status({Email? email, Password? password}) {
    final _email = email ?? state.email!;
    final _password = password ?? state.password;

    if (_email.valid && _password!.valid) return LoginStatus.valid;

    return LoginStatus.invalid;
  }

  LoginStatus _passwordlessStatus({required Email passwordlessEmail}) {
    if (passwordlessEmail.valid) return LoginStatus.passwordlessValid;
    return LoginStatus.invalid;
  }

  User _toUser(UserEntity entity) => User.fromEntity(entity);
}
