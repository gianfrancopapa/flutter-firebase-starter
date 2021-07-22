// ignore_for_file: prefer_const_constructors
import 'package:firebasestarter/forgot_password/forgot_password.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgotPasswordState', () {
    test('has valid initial state', () {
      expect(
        ForgotPasswordState.initial(),
        equals(
          ForgotPasswordState(
            status: ForgotPasswordStatus.initial,
            email: Email.pure(),
          ),
        ),
      );
    });

    test('supports value comparison', () {
      expect(
        ForgotPasswordState(status: ForgotPasswordStatus.initial),
        equals(ForgotPasswordState(status: ForgotPasswordStatus.initial)),
      );
    });

    group('copyWith', () {
      test('returns same object when no properties are passed', () {
        expect(
          ForgotPasswordState(status: ForgotPasswordStatus.initial).copyWith(),
          equals(ForgotPasswordState(status: ForgotPasswordStatus.initial)),
        );
      });

      test('returns object with updated status when passed', () {
        expect(
          ForgotPasswordState(status: ForgotPasswordStatus.initial)
              .copyWith(status: ForgotPasswordStatus.loading),
          equals(ForgotPasswordState(status: ForgotPasswordStatus.loading)),
        );
      });

      test('returns object with updated email when passed', () {
        expect(
          ForgotPasswordState(status: ForgotPasswordStatus.initial)
              .copyWith(email: Email.dirty('test@gmail.com')),
          equals(
            ForgotPasswordState(
              status: ForgotPasswordStatus.initial,
              email: Email.dirty('test@gmail.com'),
            ),
          ),
        );
      });
    });
  });
}
