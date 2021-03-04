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

  LoginBloc() : super(const NotDetermined()) {
    _authService = GetIt.I<AuthService>();
    _analyticsService = GetIt.I<AnalyticsService>();
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    switch (event.runtimeType) {
      case StartLogin:
        yield* _login();
        break;
      case StartGoogleLogin:
        yield* _signIn(_authService.signInWithGoogle, 'google');
        break;
      case StartAppleLogin:
        yield* _signIn(_authService.signInWithApple, 'apple');
        break;
      case StartFacebookLogin:
        yield* _signIn(_authService.signInWithFacebook, 'facebook');
        break;
      case StartAnonymousLogin:
        yield* _signIn(_authService.signInAnonymously, 'anonymous');
        break;
      case StartLogout:
        yield* _logout();
        break;
      case CheckIfUserIsLoggedIn:
        yield* _checkIfUserIsLoggedIn();
        break;
      default:
        yield const ErrorLogin(_errEvent);
    }
  }

  Stream<LoginState> _login() async* {
    yield const Loading();
    try {
      final user = await _authService.signInWithEmailAndPassword(
        form.emailValue,
        form.passwordValue,
      );
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  Stream<LoginState> _signIn(
      Future<User> Function() signInMethod, String loginMethod) async* {
    _analyticsService.logLogin(loginMethod);
    yield const Loading();
    try {
      final user = await signInMethod();
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  Stream<LoginState> _logout() async* {
    _analyticsService.logLogout();
    yield const Loading();
    try {
      await _authService.signOut();
      yield const LoggedOut();
    } catch (e) {
      yield const ErrorLogin('Error while trying to log out');
    }
  }

  Stream<LoginState> _checkIfUserIsLoggedIn() async* {
    yield const Loading();
    try {
      final user = await _authService.currentUser();
      if (user != null) {
        yield LoggedIn(user);
      } else {
        yield const LoggedOut();
      }
    } catch (e) {
      yield const ErrorLogin(
          'Error while trying to verify if user is logged in');
    }
  }
}
