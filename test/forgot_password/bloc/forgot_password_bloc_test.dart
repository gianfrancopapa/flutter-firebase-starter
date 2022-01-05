// ignore_for_file: avoid_returning_null_for_void

import 'package:auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/forgot_password/forgot_password.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'forgot_password_bloc_test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  group(
    'ForgotPasswordBloc',
    () {
      final validEmail = Email.dirty('test@gmail.com');
      final invalidEmail = Email.dirty('test');

      late AuthService mockAuthService;

      setUp(() {
        mockAuthService = MockAuthService();
      });

      test('has valid initial state', () {
        expect(
          ForgotPasswordBloc(authService: mockAuthService).state,
          equals(ForgotPasswordState.initial()),
        );
      });

      blocTest<ForgotPasswordBloc, ForgotPasswordState>(
        'calls authService.sendPasswordResetEmail',
        seed: () => ForgotPasswordState(
          status: ForgotPasswordStatus.initial,
          email: validEmail,
        ),
        act: (bloc) => bloc.add(const ForgotPasswordResetRequested()),
        build: () {
          when(mockAuthService.sendPasswordResetEmail(email: validEmail.value!))
              .thenAnswer((_) async => null);

          return ForgotPasswordBloc(authService: mockAuthService);
        },
        verify: (_) {
          verify(
            mockAuthService.sendPasswordResetEmail(email: validEmail.value!),
          ).called(1);
        },
      );

      blocTest<ForgotPasswordBloc, ForgotPasswordState>(
        'does not call authService.sendPasswordResetEmail '
        'when email is invalid',
        seed: () => ForgotPasswordState(
          status: ForgotPasswordStatus.initial,
          email: invalidEmail,
        ),
        act: (bloc) => bloc.add(const ForgotPasswordResetRequested()),
        build: () {
          return ForgotPasswordBloc(authService: mockAuthService);
        },
        verify: (_) {
          verifyNever(
            mockAuthService.sendPasswordResetEmail(email: invalidEmail.value!),
          );
        },
      );

      blocTest<ForgotPasswordBloc, ForgotPasswordState>(
        'emits [loading, success] when '
        'authService.sendPasswordResetEmail succeeds',
        seed: () => ForgotPasswordState(
          status: ForgotPasswordStatus.initial,
          email: validEmail,
        ),
        act: (bloc) => bloc.add(const ForgotPasswordResetRequested()),
        build: () {
          when(mockAuthService.sendPasswordResetEmail(email: validEmail.value!))
              .thenAnswer((_) async => null);

          return ForgotPasswordBloc(authService: mockAuthService);
        },
        expect: () => <ForgotPasswordState>[
          ForgotPasswordState(
            status: ForgotPasswordStatus.loading,
            email: validEmail,
          ),
          ForgotPasswordState(
            status: ForgotPasswordStatus.success,
            email: validEmail,
          ),
        ],
      );

      blocTest<ForgotPasswordBloc, ForgotPasswordState>(
        'emits [loading, failure] when '
        'authService.sendPasswordResetEmail succeeds and email is invalid',
        seed: () => ForgotPasswordState(
          status: ForgotPasswordStatus.initial,
          email: invalidEmail,
        ),
        act: (bloc) => bloc.add(const ForgotPasswordResetRequested()),
        build: () {
          when(
            mockAuthService.sendPasswordResetEmail(email: invalidEmail.value!),
          ).thenAnswer((_) async => null);

          return ForgotPasswordBloc(authService: mockAuthService);
        },
        expect: () => <ForgotPasswordState>[
          ForgotPasswordState(
            status: ForgotPasswordStatus.loading,
            email: invalidEmail,
          ),
          ForgotPasswordState(
            status: ForgotPasswordStatus.failure,
            email: invalidEmail,
          ),
        ],
      );

      blocTest<ForgotPasswordBloc, ForgotPasswordState>(
        'emits [loading, failure] when '
        'authService.sendPasswordResetEmail throws',
        seed: () => ForgotPasswordState(
          status: ForgotPasswordStatus.initial,
          email: validEmail,
        ),
        act: (bloc) => bloc.add(const ForgotPasswordResetRequested()),
        build: () {
          when(
            mockAuthService.sendPasswordResetEmail(email: validEmail.value!),
          ).thenThrow(AuthError.error);

          return ForgotPasswordBloc(authService: mockAuthService);
        },
        expect: () => <ForgotPasswordState>[
          ForgotPasswordState(
            status: ForgotPasswordStatus.loading,
            email: validEmail,
          ),
          ForgotPasswordState(
            status: ForgotPasswordStatus.failure,
            email: validEmail,
          ),
        ],
      );

      blocTest<ForgotPasswordBloc, ForgotPasswordState>(
        'emits [valid] when email is valid',
        act: (bloc) =>
            bloc.add(ForgotPasswordEmailChanged(email: validEmail.value!)),
        build: () {
          return ForgotPasswordBloc(authService: mockAuthService);
        },
        expect: () => <ForgotPasswordState>[
          ForgotPasswordState(
            status: ForgotPasswordStatus.valid,
            email: validEmail,
          ),
        ],
      );

      blocTest<ForgotPasswordBloc, ForgotPasswordState>(
        'emits [invalid] when email is invalid',
        act: (bloc) =>
            bloc.add(ForgotPasswordEmailChanged(email: invalidEmail.value!)),
        build: () {
          return ForgotPasswordBloc(authService: mockAuthService);
        },
        expect: () => <ForgotPasswordState>[
          ForgotPasswordState(
            status: ForgotPasswordStatus.invalid,
            email: invalidEmail,
          ),
        ],
      );
    },
  );
}
