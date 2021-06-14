import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/bloc/forms/login_form_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthService _authService;
  AnalyticsService _analyticsService;
  LoginFormBloc form;

  LoginBloc({
    AuthService authService,
    LoginFormBloc form,
    AnalyticsService analyticsService,
  }) : super(const LoginState()) {
    _authService = authService ?? GetIt.I<AuthService>();
    _analyticsService = analyticsService ?? GetIt.I<AnalyticsService>();
    this.form = form ?? LoginFormBloc();
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginStarted) {
      yield* _mapLoginStartedToState();
    } else if (event is GoogleLoginStarted) {
      yield* _mapProviderLoginStartedToState(
          _authService.signInWithGoogle, 'google');
    } else if (event is AppleLoginStarted) {
      yield* _mapProviderLoginStartedToState(
          _authService.signInWithApple, 'apple');
    } else if (event is FacebookLoginStarted) {
      yield* _mapProviderLoginStartedToState(
          _authService.signInWithFacebook, 'facebook');
    } else if (event is AnonymousLoginStarted) {
      yield* _mapProviderLoginStartedToState(
          _authService.signInAnonymously, 'anonymous');
    } else if (event is LogoutStarted) {
      yield* _mapLogoutStartedToState();
    } else if (event is IsUserLoggedIn) {
      yield* _mapIsUserLoggedInToState();
    }
  }

  Stream<LoginState> _mapLoginStartedToState() async* {
    yield state.copyWith(status: LoginStatus.inProgress);
    try {
      final user = await _authService.signInWithEmailAndPassword(
        form.emailValue,
        form.passwordValue,
      );
      yield state.copyWith(
        status: LoginStatus.loginSuccess,
        currentUser: user,
      );
    } catch (e) {
      yield state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.code,
      );
    }
  }

  Stream<LoginState> _mapProviderLoginStartedToState(
    Future<User> Function() signInMethod,
    String loginMethod,
  ) async* {
    _analyticsService.logLogin(loginMethod);
    yield state.copyWith(status: LoginStatus.inProgress);
    try {
      final user = await signInMethod();
      if (user != null) {
        yield state.copyWith(
          status: LoginStatus.loginSuccess,
          currentUser: user,
        );
      }
    } catch (error) {
      yield state.copyWith(
        status: LoginStatus.failure,
        errorMessage: error,
      );
    }
  }

  Stream<LoginState> _mapLogoutStartedToState() async* {
    _analyticsService.logLogout();
    yield state.copyWith(status: LoginStatus.inProgress);
    try {
      await _authService.signOut();
      yield state.copyWith(status: LoginStatus.logoutSuccess);
    } catch (e) {
      yield state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Error while trying to log out',
      );
    }
  }

  Stream<LoginState> _mapIsUserLoggedInToState() async* {
    yield state.copyWith(status: LoginStatus.inProgress);
    try {
      final user = await _authService.currentUser();
      if (user != null) {
        yield state.copyWith(
          status: LoginStatus.loginSuccess,
          currentUser: user,
        );
      } else {
        yield state.copyWith(status: LoginStatus.logoutSuccess);
      }
    } catch (e) {
      yield state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Error while trying to verify if user is logged in',
      );
    }
  }
}
