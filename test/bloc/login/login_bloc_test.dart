import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebasestarter/bloc/forms/login_form_bloc.dart';
import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../unit/auth/mocks/auth_mocks.dart';
import '../user/mocks/user_mocks.dart';
import 'mocks/login_bloc_mocks.dart';

void main() {
  AnalyticsService analyticsService;
  MockFirebaseAuthService auth;
  LoginFormBloc form;
  User user;

  final error = Auth.FirebaseAuthException(code: 'Error');

  setUp(() {
    analyticsService = MockAnalyticsService();
    auth = MockFirebaseAuthService();
    form = MockLoginFormBloc();
    user = MockUser();
  });

  group(
    'LoginBloc /',
    () {
      test('Initial state', () {
        final loginBloc =
            LoginBloc(authService: auth, analyticsService: analyticsService);
        expect(loginBloc.state.status, LoginStatus.initial);
      });

      blocTest(
        'Login started, success',
        build: () => LoginBloc(
          authService: auth,
          // form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(form.emailValue).thenReturn('test@email.com');
          when(form.passwordValue).thenReturn('testPassword');
          when(auth.signInWithEmailAndPassword(
            'test@email.com',
            'testPassword',
          )).thenAnswer((_) async => user);
          bloc.add(const LoginStarted());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          LoginState(status: LoginStatus.loginSuccess, currentUser: user),
        ],
      );

      blocTest(
        'Login started, failure',
        build: () => LoginBloc(
          authService: auth,
          // form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(form.emailValue).thenReturn('test@email.com');
          when(form.passwordValue).thenReturn('testPassword');
          when(auth.signInWithEmailAndPassword(
            'test@email.com',
            'testPassword',
          )).thenThrow(error);
          bloc.add(const LoginStarted());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          LoginState(status: LoginStatus.failure, errorMessage: error.code),
        ],
      );

      blocTest(
        'Google login started, success',
        build: () => LoginBloc(
          authService: auth,
          // form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.signInWithGoogle()).thenAnswer((_) async => user);
          bloc.add(const GoogleLoginStarted());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          LoginState(status: LoginStatus.loginSuccess, currentUser: user),
        ],
      );

      blocTest(
        'Google login started, failure',
        build: () => LoginBloc(
          authService: auth,
          // form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.signInWithGoogle()).thenThrow(error.code);
          bloc.add(const GoogleLoginStarted());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          LoginState(status: LoginStatus.failure, errorMessage: error.code),
        ],
      );

      blocTest(
        'Apple login started, success',
        build: () => LoginBloc(
          authService: auth,
          // form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.signInWithApple()).thenAnswer((_) async => user);
          bloc.add(const AppleLoginStarted());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          LoginState(status: LoginStatus.loginSuccess, currentUser: user),
        ],
      );

      blocTest(
        'Apple login started, failure',
        build: () => LoginBloc(
          authService: auth,
          // form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.signInWithApple()).thenThrow(error.code);
          bloc.add(const AppleLoginStarted());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          LoginState(status: LoginStatus.failure, errorMessage: error.code),
        ],
      );

      blocTest(
        'Facebook login started, success',
        build: () => LoginBloc(
          authService: auth,
          // form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.signInWithFacebook()).thenAnswer((_) async => user);
          bloc.add(const FacebookLoginStarted());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          LoginState(status: LoginStatus.loginSuccess, currentUser: user),
        ],
      );

      blocTest(
        'Facebook login started, failure',
        build: () => LoginBloc(
          authService: auth,
          // form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.signInWithFacebook()).thenThrow(error.code);
          bloc.add(const FacebookLoginStarted());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          LoginState(status: LoginStatus.failure, errorMessage: error.code),
        ],
      );

      blocTest(
        'Anonymous login started, success',
        build: () => LoginBloc(
          authService: auth,
//          form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.signInAnonymously()).thenAnswer((_) async => user);
          bloc.add(const AnonymousLoginStarted());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          LoginState(status: LoginStatus.loginSuccess, currentUser: user),
        ],
      );

      blocTest(
        'Anonymous login started, failure',
        build: () => LoginBloc(
          authService: auth,
////          form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.signInAnonymously()).thenThrow(error.code);
          bloc.add(const AnonymousLoginStarted());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          LoginState(status: LoginStatus.failure, errorMessage: error.code),
        ],
      );

      blocTest(
        'Logout started, success',
        build: () => LoginBloc(
          authService: auth,
////          form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.signOut()).thenAnswer((_) async => null);
          bloc.add(const LogoutStarted());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          const LoginState(status: LoginStatus.logoutSuccess),
        ],
      );

      blocTest(
        'Logout started, failure',
        build: () => LoginBloc(
          authService: auth,
////          form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.signOut()).thenThrow('Error while trying to log out');
          bloc.add(const LogoutStarted());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          const LoginState(
            status: LoginStatus.failure,
            errorMessage: 'Error while trying to log out',
          ),
        ],
      );

      blocTest(
        'IsUserLoggedIn started, success - logged in',
        build: () => LoginBloc(
          authService: auth,
//          form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.currentUser()).thenAnswer((_) async => user);
          bloc.add(const IsUserLoggedIn());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          LoginState(status: LoginStatus.loginSuccess, currentUser: user),
        ],
      );

      blocTest(
        'IsUserLoggedIn started, success - not logged in',
        build: () => LoginBloc(
          authService: auth,
//          form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.currentUser()).thenAnswer((_) async => null);
          bloc.add(const IsUserLoggedIn());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          const LoginState(status: LoginStatus.logoutSuccess),
        ],
      );

      blocTest(
        'IsUserLoggedIn started, failure',
        build: () => LoginBloc(
          authService: auth,
//          form: form,
          analyticsService: analyticsService,
        ),
        act: (bloc) {
          when(auth.currentUser()).thenThrow('Error');
          bloc.add(const IsUserLoggedIn());
        },
        expect: () => [
          const LoginState(status: LoginStatus.inProgress),
          const LoginState(
            status: LoginStatus.failure,
            errorMessage: 'Error while trying to verify if user is logged in',
          ),
        ],
      );
    },
  );
}
