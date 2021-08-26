import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    @required AuthService authService,
    @required AnalyticsService analyticsService,
  })  : assert(authService != null),
        assert(analyticsService != null),
        _authService = authService,
        _analyticsService = analyticsService,
        super(LoginState.initial());

  final AuthService _authService;
  final AnalyticsService _analyticsService;
  final passwordlessEmailKey = 'passwordlessEmail';

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

    try {
      final user = await _authService.signInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );

      yield state.copyWith(status: LoginStatus.loggedIn, user: _toUser(user));
    } on AuthError catch (e) {
      yield state.copyWith(status: LoginStatus.failure, error: e);
    }
  }

  Stream<LoginState> _mapLoginWithSocialMediaRequestedToState(
    LoginWithSocialMediaRequested event,
  ) async* {
    yield state.copyWith(status: LoginStatus.loading);
    _analyticsService.logLogin(event.toString());

    try {
      final user = await _authService.signInWithSocialMedia(method: event.method);

      if (user != null) {
        yield state.copyWith(status: LoginStatus.loggedIn, user: _toUser(user));
      } else {
        yield state.copyWith(status: LoginStatus.loggedOut);
      }
    } on AuthError catch (e) {
      yield state.copyWith(status: LoginStatus.failure, error: e);
    }
  }

  Stream<LoginState> _mapLoginAnonymouslyRequestedToState() async* {
    yield state.copyWith(status: LoginStatus.loading);

    try {
      final user = await _authService.signInAnonymously();

      yield state.copyWith(status: LoginStatus.loggedIn, user: _toUser(user));
    } on AuthError catch (e) {
      yield state.copyWith(status: LoginStatus.failure, error: e);
    }
  }

  Stream<LoginState> _mapLoginIsSessionPersistedToState() async* {
    yield state.copyWith(status: LoginStatus.loading);

    try {
      final user = await _authService.currentUser();

      if (user != null) {
        yield state.copyWith(status: LoginStatus.loggedIn, user: _toUser(user));
        return;
      }

      yield state.copyWith(status: LoginStatus.loggedOut);
    } on AuthError catch (e) {
      yield state.copyWith(status: LoginStatus.failure, error: e);
    }
  }

  Stream<LoginState> _mapLoginEmailChangedToState(
    LoginEmailChanged event,
  ) async* {
    final email = Email.dirty(event.email);

    yield state.copyWith(
      email: email,
      status: _status(email: email),
    );
  }

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
    LoginPasswordChanged event,
  ) async* {
    final password = Password.dirty(event.password);

    yield state.copyWith(
      password: password,
      status: _status(password: password),
    );
  }

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
    final _password = password ?? state.password;

    if (_email.valid && _password.valid) return LoginStatus.valid;

    return LoginStatus.invalid;
  }

  LoginStatus _passwordlessStatus({Email passwordlessEmail}) {
    final _passwordlessEmail = passwordlessEmail ?? state.passwordlessEmail;

    if (_passwordlessEmail.valid) return LoginStatus.passwordlessValid;

    return LoginStatus.invalid;
  }

  User _toUser(UserEntity entity) => User.fromEntity(entity);
}
