import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/analytics/analytics_service.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

// ignore: must_be_immutable
class MockUser extends Mock implements User {}

void main() {
  group(
    'LoginBloc',
    () {
      AnalyticsService mockAnalyticsService;
      FirebaseAuthService mockAuthService;
      User mockUser;

      final email = Email.dirty('test@gmail.com');
      final password = Password.dirty('Password01');

      setUp(() {
        mockAnalyticsService = MockAnalyticsService();
        mockAuthService = MockFirebaseAuthService();
        mockUser = MockUser();
      });

      test('has valid initial state', () {
        expect(
          LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          ).state,
          equals(
            LoginState(
              status: LoginStatus.initial,
              email: Email.pure(),
              password: Password.pure(),
            ),
          ),
        );
      });

      blocTest<LoginBloc, LoginState>(
        'calls authService.signInWithEmailAndPassword',
        seed: () => LoginState(
          status: LoginStatus.valid,
          email: email,
          password: password,
        ),
        act: (bloc) => bloc.add(const LoginWithEmailAndPasswordRequested()),
        build: () {
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        verify: (_) {
          mockAuthService.signInWithEmailAndPassword(
            email: email.value,
            password: password.value,
          );
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, loggedIn] when '
        'authService.signInWithEmailAndPassword succeeds',
        seed: () => LoginState(
          status: LoginStatus.valid,
          email: email,
          password: password,
        ),
        act: (bloc) => bloc.add(const LoginWithEmailAndPasswordRequested()),
        build: () {
          when(
            mockAuthService.signInWithEmailAndPassword(
              email: email.value,
              password: password.value,
            ),
          ).thenAnswer((_) async => mockUser);

          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.loading,
            email: email,
            password: password,
          ),
          LoginState(
            status: LoginStatus.loggedIn,
            email: email,
            password: password,
            user: mockUser,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, failure] when '
        'authService.signInWithEmailAndPassword throws',
        seed: () => LoginState(
          status: LoginStatus.valid,
          email: email,
          password: password,
        ),
        act: (bloc) => bloc.add(const LoginWithEmailAndPasswordRequested()),
        build: () {
          when(
            mockAuthService.signInWithEmailAndPassword(
              email: email.value,
              password: password.value,
            ),
          ).thenThrow(AuthError.ERROR);

          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.loading,
            email: email,
            password: password,
          ),
          LoginState(
            status: LoginStatus.failure,
            email: email,
            password: password,
            error: AuthError.ERROR,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'calls authService.signInWithSocialMedia',
        act: (bloc) => bloc.add(
          const LoginWithSocialMediaRequested(method: SocialMediaMethod.GOOGLE),
        ),
        build: () {
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        verify: (_) {
          mockAuthService.signInWithSocialMedia(
            method: SocialMediaMethod.GOOGLE,
          );
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, loggedIn] when '
        'authService.signInWithSocialMedia succeeds and returns user',
        act: (bloc) => bloc.add(
          const LoginWithSocialMediaRequested(method: SocialMediaMethod.GOOGLE),
        ),
        build: () {
          when(
            mockAuthService.signInWithSocialMedia(
              method: SocialMediaMethod.GOOGLE,
            ),
          ).thenAnswer((_) async => mockUser);

          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.loading,
            email: Email.pure(),
            password: Password.pure(),
          ),
          LoginState(
            status: LoginStatus.loggedIn,
            user: mockUser,
            email: Email.pure(),
            password: Password.pure(),
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, loggedOut] when '
        'authService.signInWithSocialMedia succeeds and returns null',
        act: (bloc) => bloc.add(
          const LoginWithSocialMediaRequested(method: SocialMediaMethod.GOOGLE),
        ),
        build: () {
          when(
            mockAuthService.signInWithSocialMedia(
              method: SocialMediaMethod.GOOGLE,
            ),
          ).thenAnswer((_) async => null);

          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState.initial().copyWith(status: LoginStatus.loading),
          LoginState.initial().copyWith(status: LoginStatus.loggedOut),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, failure] when '
        'authService.signInWithSocialMedia throws',
        act: (bloc) => bloc.add(
          const LoginWithSocialMediaRequested(method: SocialMediaMethod.GOOGLE),
        ),
        build: () {
          when(
            mockAuthService.signInWithSocialMedia(
              method: SocialMediaMethod.GOOGLE,
            ),
          ).thenThrow(AuthError.ERROR);

          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.loading,
            email: Email.pure(),
            password: Password.pure(),
          ),
          LoginState(
            status: LoginStatus.failure,
            email: Email.pure(),
            password: Password.pure(),
            error: AuthError.ERROR,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'calls authService.signOut',
        build: () {
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        verify: (_) {
          mockAuthService.signOut();
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, loggedOut] when authService.signOut succeeds',
        act: (bloc) => bloc.add(const LogoutRequested()),
        build: () {
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.loading,
            email: Email.pure(),
            password: Password.pure(),
          ),
          LoginState(
            status: LoginStatus.loggedOut,
            email: Email.pure(),
            password: Password.pure(),
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, failure] when authService.signOut throws',
        act: (bloc) => bloc.add(const LogoutRequested()),
        build: () {
          when(mockAuthService.signOut()).thenThrow(AuthError.ERROR);

          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.loading,
            email: Email.pure(),
            password: Password.pure(),
          ),
          LoginState(
            status: LoginStatus.failure,
            email: Email.pure(),
            password: Password.pure(),
            error: AuthError.ERROR,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'calls authService.currentUser',
        act: (bloc) => bloc.add(const LoginIsSessionPersisted()),
        build: () {
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        verify: (_) {
          mockAuthService.currentUser();
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, loggedIn] when authService.currentUser '
        'returns an User',
        act: (bloc) => bloc.add(const LoginIsSessionPersisted()),
        build: () {
          when(mockAuthService.currentUser()).thenAnswer((_) async => mockUser);

          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.loading,
            email: Email.pure(),
            password: Password.pure(),
          ),
          LoginState(
            status: LoginStatus.loggedIn,
            email: Email.pure(),
            password: Password.pure(),
            user: mockUser,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, loggedOut] when authService.currentUser '
        'returns null',
        act: (bloc) => bloc.add(const LoginIsSessionPersisted()),
        build: () {
          when(mockAuthService.currentUser()).thenAnswer((_) async => null);

          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.loading,
            email: Email.pure(),
            password: Password.pure(),
          ),
          LoginState(
            status: LoginStatus.loggedOut,
            email: Email.pure(),
            password: Password.pure(),
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, failure] when authService.currentUser throws',
        act: (bloc) => bloc.add(const LoginIsSessionPersisted()),
        build: () {
          when(mockAuthService.currentUser()).thenThrow(AuthError.ERROR);

          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.loading,
            email: Email.pure(),
            password: Password.pure(),
          ),
          LoginState(
            status: LoginStatus.failure,
            email: Email.pure(),
            password: Password.pure(),
            error: AuthError.ERROR,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [valid] when email is valid and password is valid',
        seed: () => LoginState(status: LoginStatus.valid, password: password),
        act: (bloc) => bloc.add(LoginEmailChanged(email: email.value)),
        build: () {
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.valid,
            password: password,
            email: email,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [invalid] when email is valid and password is invalid',
        seed: () => LoginState(
          status: LoginStatus.valid,
          password: Password.pure(),
        ),
        act: (bloc) => bloc.add(LoginEmailChanged(email: email.value)),
        build: () {
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.invalid,
            password: Password.pure(),
            email: email,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [valid] when password is valid and email is valid',
        seed: () => LoginState(status: LoginStatus.valid, email: email),
        act: (bloc) => bloc.add(LoginPasswordChanged(password: password.value)),
        build: () {
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.valid,
            password: password,
            email: email,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [invalid] when password is valid and email is invalid',
        seed: () => LoginState(
          status: LoginStatus.valid,
          email: Email.pure(),
        ),
        act: (bloc) => bloc.add(LoginPasswordChanged(password: password.value)),
        build: () {
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState(
            status: LoginStatus.invalid,
            password: password,
            email: Email.pure(),
          ),
        ],
      );
    },
  );
}
