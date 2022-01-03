// ignore_for_file: prefer_const_constructors
import 'package:firebasestarter/login/login.dart';
import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginEvent', () {
    group('LoginWithEmailAndPasswordRequested', () {
      test('supports value comparison', () {
        expect(
          LoginWithEmailAndPasswordRequested(),
          equals(
            LoginWithEmailAndPasswordRequested(),
          ),
        );
      });
    });

    group('LoginWithSocialMediaRequested', () {
      test('supports value comparison', () {
        expect(
          LoginWithSocialMediaRequested(method: SocialMediaMethod.apple),
          equals(
            LoginWithSocialMediaRequested(method: SocialMediaMethod.apple),
          ),
        );
      });
    });

    group('LoginAnonymouslyRequested', () {
      test('supports value comparison', () {
        expect(
          LoginAnonymouslyRequested(),
          equals(
            LoginAnonymouslyRequested(),
          ),
        );
      });
    });

    group('LoginIsSessionPersisted', () {
      test('supports value comparison', () {
        expect(
          LoginIsSessionPersisted(),
          equals(
            LoginIsSessionPersisted(),
          ),
        );
      });
    });

    group('LoginEmailChanged', () {
      const email = 'test@gmail.com';

      test('supports value comparison', () {
        expect(
          LoginEmailChanged(email: email),
          equals(
            LoginEmailChanged(email: email),
          ),
        );
      });
    });

    group('LoginPasswordChanged', () {
      const password = 'Password01';

      test('supports value comparison', () {
        expect(
          LoginPasswordChanged(password: password),
          equals(
            LoginPasswordChanged(password: password),
          ),
        );
      });
    });
  });
}
