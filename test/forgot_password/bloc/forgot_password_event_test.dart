// ignore_for_file: prefer_const_constructors
import 'package:firebasestarter/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForgotPasswordEvent', () {
    group('ForgotPasswordEmailChanged', () {
      const email = 'email@email.com';
      test('supports value comparison', () {
        expect(
          ForgotPasswordEmailChanged(email: email),
          equals(ForgotPasswordEmailChanged(email: email)),
        );
      });
    });

    group('ForgotPasswordResetRequested', () {
      test('supports value comparison', () {
        expect(
          ForgotPasswordResetRequested(),
          equals(ForgotPasswordResetRequested()),
        );
      });
    });
  });
}
