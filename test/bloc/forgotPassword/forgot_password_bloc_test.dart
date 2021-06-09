import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_event.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_state.dart';
import 'package:firebasestarter/bloc/forms/forgot_password_form.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../unit/auth/mocks/auth_mocks.dart';
import 'mocks/forgot_password_bloc_mocks.dart';

void main() {
  AuthService auth;
  ForgotPasswordFormBloc form;

  const error = 'Error: Something went wrong while trying to recover password';

  setUp(() {
    auth = MockAuthService();
    form = MockForgotPasswordFormBloc();
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
        build: () => ForgotPasswordBloc(authService: auth, form: form),
        act: (bloc) {
          when(form.emailValue).thenReturn('test@email.com');
          when(auth.sendPasswordResetEmail('test@email.com'))
              .thenAnswer((_) async => null);
          bloc.add(const PasswordReset());
        },
        expect: () => [
          const ForgotPasswordState(status: ForgotPasswordStatus.inProgress),
          const ForgotPasswordState(status: ForgotPasswordStatus.emailSent),
        ],
      );

      blocTest(
        'PasswordReset started, failure',
        build: () => ForgotPasswordBloc(authService: auth, form: form),
        act: (bloc) {
          when(form.emailValue).thenReturn('test@email.com');
          when(auth.sendPasswordResetEmail('test@email.com')).thenThrow(error);
          bloc.add(const PasswordReset());
        },
        expect: () => [
          const ForgotPasswordState(status: ForgotPasswordStatus.inProgress),
          const ForgotPasswordState(
            status: ForgotPasswordStatus.failure,
            errorMessage: error,
          ),
        ],
      );

      blocTest(
        'Invalid event started, failure',
        build: () => ForgotPasswordBloc(authService: auth, form: form),
        act: (bloc) {
          bloc.add(null);
        },
        expect: () => [
          const ForgotPasswordState(
            status: ForgotPasswordStatus.failure,
            errorMessage: 'Error: Invalid event in [forgot_password_bloc.dart]',
          ),
        ],
      );
    },
  );
}
