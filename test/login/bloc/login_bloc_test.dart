import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:auth/auth.dart';
import 'package:firebasestarter/services/analytics/analyitics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_bloc_test.mocks.dart';

@GenerateMocks(
  [AnalyticsService, FirebaseAuthService, UserEntity],
)
void main() {
  group(
    'LoginBloc',
    () {
      late AnalyticsService mockAnalyticsService;
      late FirebaseAuthService mockAuthService;
      UserEntity? mockUser;

      final email = Email.dirty('test@gmail.com');
      final password = Password.dirty('Password01');

      setUp(() {
        mockAnalyticsService = MockAnalyticsService();
        mockAuthService = MockFirebaseAuthService();
        mockUser = MockUserEntity();
        when(mockUser!.id).thenReturn('1');
        when(mockUser!.firstName).thenReturn('firstName');
        when(mockUser!.lastName).thenReturn('lastName');
        when(mockUser!.email).thenReturn('email@email.com');
        when(mockUser!.imageUrl).thenReturn('https://mock-image.com');
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
          when(mockAuthService.signInWithEmailAndPassword(
                  email: email.value!, password: password.value!))
              .thenAnswer((_) async => const UserEntity());
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        verify: (_) {
          verify(
            mockAuthService.signInWithEmailAndPassword(
              email: email.value!,
              password: password.value!,
            ),
          ).called(1);
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
              email: email.value!,
              password: password.value!,
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
            user: User.fromEntity(mockUser!),
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
              email: email.value!,
              password: password.value!,
            ),
          ).thenThrow(AuthError.error);

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
            error: AuthError.error,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'calls authService.signInWithSocialMedia',
        act: (bloc) => bloc.add(
          const LoginWithSocialMediaRequested(method: SocialMediaMethod.google),
        ),
        build: () {
          when(mockAuthService.signInWithSocialMedia(
            method: SocialMediaMethod.google,
          )).thenAnswer((_) async => const UserEntity());
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        verify: (_) {
          verify(
            mockAuthService.signInWithSocialMedia(
              method: SocialMediaMethod.google,
            ),
          ).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, loggedIn] when '
        'authService.signInWithSocialMedia succeeds and returns user',
        act: (bloc) => bloc.add(
          const LoginWithSocialMediaRequested(method: SocialMediaMethod.google),
        ),
        build: () {
          when(
            mockAuthService.signInWithSocialMedia(
              method: SocialMediaMethod.google,
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
            user: User.fromEntity(mockUser!),
            email: Email.pure(),
            password: Password.pure(),
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, loggedOut] when '
        'authService.signInWithSocialMedia succeeds and returns null',
        act: (bloc) => bloc.add(
          const LoginWithSocialMediaRequested(method: SocialMediaMethod.google),
        ),
        build: () {
          when(
            mockAuthService.signInWithSocialMedia(
              method: SocialMediaMethod.google,
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
          const LoginWithSocialMediaRequested(method: SocialMediaMethod.google),
        ),
        build: () {
          when(
            mockAuthService.signInWithSocialMedia(
              method: SocialMediaMethod.google,
            ),
          ).thenThrow(AuthError.error);

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
            error: AuthError.error,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'calls authService.signInAnonymously',
        act: (bloc) => bloc.add(const LoginAnonymouslyRequested()),
        build: () {
          when(mockAuthService.signInAnonymously())
              .thenAnswer((_) async => const UserEntity());
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        verify: (_) {
          verify(mockAuthService.signInAnonymously()).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, loggedIn] when authService.signInAnonymously succeeds',
        act: (bloc) => bloc.add(const LoginAnonymouslyRequested()),
        build: () {
          when(mockAuthService.signInAnonymously())
              .thenAnswer((_) async => mockUser);

          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState.initial().copyWith(status: LoginStatus.loading),
          LoginState.initial().copyWith(
            status: LoginStatus.loggedIn,
            user: User.fromEntity(mockUser!),
          )
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [loading, failure] when authService.signInAnonymously throws',
        act: (bloc) => bloc.add(const LoginAnonymouslyRequested()),
        build: () {
          when(mockAuthService.signInAnonymously()).thenThrow(AuthError.error);

          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        expect: () => <LoginState>[
          LoginState.initial().copyWith(status: LoginStatus.loading),
          LoginState.initial().copyWith(
            status: LoginStatus.failure,
            error: AuthError.error,
          )
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'calls authService.currentUser',
        act: (bloc) => bloc.add(const LoginIsSessionPersisted()),
        build: () {
          when(mockAuthService.currentUser()).thenAnswer((_) async => mockUser);
          return LoginBloc(
            authService: mockAuthService,
            analyticsService: mockAnalyticsService,
          );
        },
        verify: (_) {
          verify(mockAuthService.currentUser()).called(1);
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
            user: User.fromEntity(mockUser!),
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
          when(mockAuthService.currentUser()).thenThrow(AuthError.error);

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
            error: AuthError.error,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'emits [valid] when email is valid and password is valid',
        seed: () => LoginState(status: LoginStatus.valid, password: password),
        act: (bloc) => bloc.add(LoginEmailChanged(email: email.value!)),
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
        act: (bloc) => bloc.add(LoginEmailChanged(email: email.value!)),
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
        act: (bloc) =>
            bloc.add(LoginPasswordChanged(password: password.value!)),
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
        act: (bloc) =>
            bloc.add(LoginPasswordChanged(password: password.value!)),
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
