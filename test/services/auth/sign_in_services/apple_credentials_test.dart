import 'package:firebasestarter/services/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() {
  group('AppleCredentials', () {
    AppleCredentials subject;

    setUp(() {
      subject = const AppleCredentials();
    });

    test('throwsAssertionError when scopes is null', () {
      expect(
        subject.getAppleCredentials(scopes: null, token: 'token'),
        throwsAssertionError,
      );
    });

    test('throwsAssertionError when token is null', () {
      expect(
        subject.getAppleCredentials(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          token: null,
        ),
        throwsAssertionError,
      );
    });
  });
}
