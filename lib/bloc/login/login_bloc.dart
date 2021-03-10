import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/bloc/forms/login_form_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  static const _errEvent = 'Error: Invalid event in [login_bloc.dart]';
  AuthService _authService;
  AnalyticsService _analyticsService;
  final form = LoginFormBloc();

  LoginBloc() : super(const LoginInitial()) {
    _authService = GetIt.I<AuthService>();
    _analyticsService = GetIt.I<AnalyticsService>();
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    switch (event.runtimeType) {
      case LoginStarted:
        yield* _mapLoginStartedToState();
        break;
      case GoogleLoginStarted:
        yield* _mapProviderLoginStartedToState(
            _authService.signInWithGoogle, 'google');
        break;
      case AppleLoginStarted:
        yield* _mapProviderLoginStartedToState(
            _authService.signInWithApple, 'apple');
        break;
      case FacebookLoginStarted:
        yield* _mapProviderLoginStartedToState(
            _authService.signInWithFacebook, 'facebook');
        break;
      case AnonymousLoginStarted:
        yield* _mapProviderLoginStartedToState(
            _authService.signInAnonymously, 'anonymous');
        break;
      case LogoutStarted:
        yield* _mapLogoutStartedToState();
        break;
      case IsUserLoggedIn:
        yield* _mapIsUserLoggedInToState();
        break;
      default:
        yield const LoginFailure(_errEvent);
    }
  }

  Stream<LoginState> _mapLoginStartedToState() async* {
    yield const LoginInProgress();
    try {
      final user = await _authService.signInWithEmailAndPassword(
        form.emailValue,
        form.passwordValue,
      );
      yield LoginSuccess(user);
    } catch (e) {
      yield LoginFailure(e.toString());
    }
  }

  Stream<LoginState> _mapProviderLoginStartedToState(
      Future<User> Function() signInMethod, String loginMethod) async* {
    _analyticsService.logLogin(loginMethod);
    yield const LoginInProgress();
    try {
      final user = await signInMethod();
      yield LoginSuccess(user);
    } catch (e) {
      yield LoginFailure(e.toString());
    }
  }

  Stream<LoginState> _mapLogoutStartedToState() async* {
    _analyticsService.logLogout();
    yield const LoginInProgress();
    try {
      await _authService.signOut();
      yield const LogoutSuccess();
    } catch (e) {
      yield const LoginFailure('Error while trying to log out');
    }
  }

  Stream<LoginState> _mapIsUserLoggedInToState() async* {
    yield const LoginInProgress();
    try {
      final user = await _authService.currentUser();
      if (user != null) {
        yield LoginSuccess(user);
      } else {
        yield const LogoutSuccess();
      }
    } catch (e) {
      yield const LoginFailure(
          'Error while trying to verify if user is logged in');
    }
  }
}
