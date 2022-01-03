// ignore_for_file: prefer_const_constructors
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginState', () {
    test('has valid initial state', () {
      expect(
        LoginState.initial(),
        equals(
          LoginState(
            status: LoginStatus.initial,
            email: Email.pure(),
            password: Password.pure(),
          ),
        ),
      );
    });

    test('supports value comparison', () {
      expect(
        LoginState(status: LoginStatus.initial),
        equals(
          LoginState(status: LoginStatus.initial),
        ),
      );
    });

    group('copyWith', () {
      test('returns same object when no properties are passed', () {
        expect(
          LoginState(status: LoginStatus.initial).copyWith(),
          equals(
            LoginState(status: LoginStatus.initial),
          ),
        );
      });

      test('returns object whit updated status when passed', () {
        expect(
          LoginState(status: LoginStatus.initial).copyWith(
            status: LoginStatus.loading,
          ),
          equals(
            LoginState(status: LoginStatus.loading),
          ),
        );
      });

      test('returns object whit updated email when passed', () {
        expect(
          LoginState(status: LoginStatus.initial).copyWith(
            email: Email.dirty('test@gmail.com'),
          ),
          equals(
            LoginState(
              status: LoginStatus.initial,
              email: Email.dirty('test@gmail.com'),
            ),
          ),
        );
      });

      test('returns object whit updated password when passed', () {
        expect(
          LoginState(status: LoginStatus.initial).copyWith(
            password: Password.dirty('Password01'),
          ),
          equals(
            LoginState(
              status: LoginStatus.initial,
              password: Password.dirty('Password01'),
            ),
          ),
        );
      });

      test('returns object whit updated user when passed', () {
        expect(
          LoginState(status: LoginStatus.initial).copyWith(
            user: User(id: '1'),
          ),
          equals(
            LoginState(
              status: LoginStatus.initial,
              user: User(id: '1'),
            ),
          ),
        );
      });

      test('returns object whit updated error when passed', () {
        expect(
          LoginState(status: LoginStatus.failure).copyWith(
            error: AuthError.error,
          ),
          equals(
            LoginState(
              status: LoginStatus.failure,
              error: AuthError.error,
            ),
          ),
        );
      });
    });
  });
}
