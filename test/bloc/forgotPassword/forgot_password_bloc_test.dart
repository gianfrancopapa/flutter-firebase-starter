import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_event.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_state.dart';
import 'package:firebasestarter/bloc/forms/forgot_password_form.dart';
import 'package:somnio_firebase_authentication/src/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../accountCreation/mocks/account_creation_bloc_mocks.dart';
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
    },
  );
}
