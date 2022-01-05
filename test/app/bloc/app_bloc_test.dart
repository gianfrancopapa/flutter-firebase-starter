// ignore_for_file: prefer_const_constructors, avoid_returning_null_for_void
import 'package:auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/shared_preferences/local_persistance_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'app_bloc_test.mocks.dart';

@GenerateMocks([LocalPersistanceService, AuthService])
void main() {
  group('AppBloc', () {
    late LocalPersistanceService mockLocalPersistanceService;
    late AuthService mockAuthService;

    final user = User(
      id: '0',
      firstName: 'firstName',
      lastName: 'lastName',
      email: 'test@gmail.com',
      imageUrl: 'https://fake-image.com',
    );

    setUp(() {
      mockLocalPersistanceService = MockLocalPersistanceService();
      mockAuthService = MockAuthService();

      when(mockAuthService.onAuthStateChanged)
          .thenAnswer((_) => Stream.empty());
    });

    test('has valid initial state', () {
      expect(
        AppBloc(
          authService: mockAuthService,
          localPersistanceService: mockLocalPersistanceService,
        ).state,
        equals(
          AppState(
            status: AppStatus.initial,
          ),
        ),
      );
    });

    group('AppIsFirstTimeLaunched', () {
      blocTest<AppBloc, AppState>(
        'calls localPersistanceService.getValue',
        act: (bloc) => bloc.add(AppIsFirstTimeLaunched()),
        build: () {
          when(mockLocalPersistanceService.getValue('is_first_time'))
              .thenAnswer((_) async => false);
          return AppBloc(
            authService: mockAuthService,
            localPersistanceService: mockLocalPersistanceService,
          );
        },
        verify: (_) {
          verify(mockLocalPersistanceService.getValue('is_first_time'))
              .called(1);
        },
      );

      blocTest<AppBloc, AppState>(
        'emits [firstTime] when localPersistanceService.getValue '
        'returns true',
        act: (bloc) => bloc.add(AppIsFirstTimeLaunched()),
        build: () {
          when(mockLocalPersistanceService.getValue('is_first_time'))
              .thenAnswer((_) async => true);

          return AppBloc(
            authService: mockAuthService,
            localPersistanceService: mockLocalPersistanceService,
          );
        },
        // As we have Future.delayed(const Duration(seconds: 2)); we need to ask blocTest to also wait for 2 seconds!
        wait: Duration(seconds: 3),
        verify: (_) {
          verify(mockLocalPersistanceService.setValue('is_first_time', false))
              .called(1);
        },
        expect: () => <AppState>[
          AppState(status: AppStatus.firstTime),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits [unauthenticated] when localPersistanceService.getValue '
        'returns false',
        act: (bloc) => bloc.add(AppIsFirstTimeLaunched()),
        build: () {
          when(mockLocalPersistanceService.getValue('is_first_time'))
              .thenAnswer((_) async => false);

          return AppBloc(
            authService: mockAuthService,
            localPersistanceService: mockLocalPersistanceService,
          );
        },
        // As we have Future.delayed(const Duration(seconds: 2)); we need to ask blocTest to also wait for 2 seconds!
        wait: Duration(seconds: 3),
        expect: () => <AppState>[
          AppState(status: AppStatus.unauthenticated),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits [failure] when localPersistanceService.getValue throws',
        act: (bloc) => bloc.add(AppIsFirstTimeLaunched()),
        build: () {
          when(mockLocalPersistanceService.getValue('is_first_time'))
              .thenThrow(Exception());

          return AppBloc(
            authService: mockAuthService,
            localPersistanceService: mockLocalPersistanceService,
          );
        },
        expect: () => <AppState>[
          AppState(status: AppStatus.failure),
        ],
      );
    });

    group('AppUserChanged', () {
      blocTest<AppBloc, AppState>(
        'emits [authenticated] when User is not empty',
        act: (bloc) => bloc.add(AppUserChanged(user: user)),
        build: () {
          return AppBloc(
            authService: mockAuthService,
            localPersistanceService: mockLocalPersistanceService,
          );
        },
        expect: () => <AppState>[
          AppState(
            status: AppStatus.authenticated,
            user: user,
          ),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits [User.empty, unauthenticated] when '
        'User is empty and isNotFirstTime',
        act: (bloc) => bloc.add(AppUserChanged(user: User.empty)),
        build: () {
          when(mockLocalPersistanceService.getValue('is_first_time'))
              .thenAnswer((_) async => false);

          return AppBloc(
            authService: mockAuthService,
            localPersistanceService: mockLocalPersistanceService,
          );
        },
        // As we have Future.delayed(const Duration(seconds: 2)); we need to ask blocTest to also wait for 2 seconds!
        wait: Duration(seconds: 3),
        expect: () => <AppState>[
          AppState(
            status: AppStatus.initial,
            user: User.empty,
          ),
          AppState(
            status: AppStatus.unauthenticated,
            user: User.empty,
          ),
        ],
      );
    });

    group('AppLogoutRequested', () {
      blocTest<AppBloc, AppState>(
        'calls authService.signOut',
        act: (bloc) => bloc.add(AppLogoutRequsted()),
        build: () {
          return AppBloc(
            authService: mockAuthService,
            localPersistanceService: mockLocalPersistanceService,
          );
        },
        verify: (_) {
          verify(mockAuthService.signOut()).called(1);
        },
      );

      blocTest<AppBloc, AppState>(
        'emits [unauthenticated] when authService.signOut succeeds',
        act: (bloc) => bloc.add(AppLogoutRequsted()),
        build: () {
          when(mockAuthService.signOut()).thenAnswer((_) async => null);

          return AppBloc(
            authService: mockAuthService,
            localPersistanceService: mockLocalPersistanceService,
          );
        },
        expect: () => <AppState>[
          AppState(
            status: AppStatus.unauthenticated,
            user: User.empty,
          ),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits [failure] when authService.signOut throws',
        act: (bloc) => bloc.add(AppLogoutRequsted()),
        build: () {
          when(mockAuthService.signOut()).thenThrow(AuthError.error);

          return AppBloc(
            authService: mockAuthService,
            localPersistanceService: mockLocalPersistanceService,
          );
        },
        expect: () => <AppState>[
          AppState(status: AppStatus.failure),
        ],
      );
    });
  });
}
