import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_event.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_state.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../unit/auth/mocks/auth_mocks.dart';

void main() {
  AuthService auth;

  const error = 'Error: Something went wrong while trying to recover password';

  setUp(() {
    auth = MockAuthService();
    EquatableConfig.stringify = true;
  });

  group(
    'ForgotPasswordBloc /',
    () {
      test('Initial state', () {
        final loginBloc = ForgotPasswordBloc(authService: auth);
        expect(loginBloc.state.status, ForgotPasswordStatus.initial);
      });

      blocTest(
        'PasswordReset started, success',
        build: () => ForgotPasswordBloc(authService: auth)
          ..add(const EmailAddressUpdated(emailAddress: 'test@email.com')),
        act: (bloc) {
          when(auth.sendPasswordResetEmail(email: 'test@email.com'))
              .thenAnswer((_) async => null);
          bloc.add(const PasswordReset());
        },
        skip: 1,
        expect: () => [
          const ForgotPasswordState(
              status: ForgotPasswordStatus.inProgress,
              emailAddress: 'test@email.com'),
          const ForgotPasswordState(
              status: ForgotPasswordStatus.emailSent,
              emailAddress: 'test@email.com'),
        ],
      );

      blocTest(
        'PasswordReset started, failure',
        build: () => ForgotPasswordBloc(authService: auth)
          ..add(const EmailAddressUpdated(emailAddress: 'test@email.com')),
        act: (bloc) {
          when(auth.sendPasswordResetEmail(email: 'test@email.com'))
              .thenThrow(error);
          bloc.add(const PasswordReset());
        },
        skip: 1,
        expect: () => [
          const ForgotPasswordState(
              status: ForgotPasswordStatus.inProgress,
              emailAddress: 'test@email.com'),
          const ForgotPasswordState(
            status: ForgotPasswordStatus.failure,
            errorMessage: error,
            emailAddress: 'test@email.com',
          ),
        ],
      );
    },
  );
}
