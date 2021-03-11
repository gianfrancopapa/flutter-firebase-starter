import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/bloc/forms/login_form_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

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
      yield LoginFailure(_determineAccessError(e));
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
      yield LoginFailure(_determineAccessError(e));
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

  String _determineAccessError(FirebaseAuthException exception) {
    const error = 'Error:';
    var message;
    switch (exception.code) {
      case 'invalid-email':
        message = 'Invalid email.';
        break;
      case 'user-disabled':
        message = 'This user has been disabled.';
        break;
      case 'user-not-found':
        message = 'There is no user linked with this email.';
        break;
      case 'wrong-password':
        message =
            'The password is invalid or the user does not have a password.';
        break;
      case 'email-already-in-use':
      case 'account-exists-with-different-credential':
        message = 'An account with this email already exists.';
        break;
      case 'invalid-credential':
        message = 'Invalid credential.';
        break;
      case 'operation-not-allowed':
        message = 'You do not have permission to perform this action.';
        break;
      case 'weak-password':
        message =
            'Insert a password with at least 6 characters that contains at least one uppercase letter and one number.';
        break;
      case 'ERROR_ABORTED_BY_USER':
        message = 'Sign in aborted by user.';
        break;
      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
        message = 'Missing Google auth token.';
        break;
      default:
        message = 'An error occurs';
    }
    return error + ' ' + message;
  }
}
