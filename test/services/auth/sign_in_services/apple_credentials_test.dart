import 'package:flutter_test/flutter_test.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:auth/auth.dart';

void main() {
  group('AppleCredentials', () {
    late AppleCredentials subject;

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
