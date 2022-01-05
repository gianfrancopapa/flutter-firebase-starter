import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:auth/auth.dart';

import 'apple_sign_in_service_test.mocks.dart';

@GenerateMocks([AppleCredentials, AuthorizationCredentialAppleID])
void main() {
  group('AppleSignInService', () {
    AppleCredentials? mockAppleCredentials;
    AuthorizationCredentialAppleID? mockAuthorizationCredential;

    late AppleSignInService subject;

    setUp(() {
      mockAppleCredentials = MockAppleCredentials();
      mockAuthorizationCredential = MockAuthorizationCredentialAppleID();

      when(mockAuthorizationCredential!.identityToken).thenReturn('idToken');

      subject = AppleSignInService(appleCredentials: mockAppleCredentials!);
    });

    group(
      '.getFirebaseCredential',
      () {
        test('completes when appleCredentials.getAppleCredentials succeeds',
            () {
          when(
            mockAppleCredentials!.getAppleCredentials(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
              ],
              token: anyNamed('token'),
            ),
          ).thenAnswer(((_) async => mockAuthorizationCredential!));

          expect(subject.getFirebaseCredential(), completes);
        });

        test('fails when appleCredentials.getAppleCredentials throws', () {
          when(
            mockAppleCredentials!.getAppleCredentials(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
              ],
              token: anyNamed('token'),
            ),
          ).thenThrow(Exception());

          expect(
            subject.getFirebaseCredential(),
            throwsA(isA<FirebaseAuthException>()),
          );
        });
      },
    );

    group('.signOut', () {
      test('completes', () {
        expect(subject.signOut(), completes);
      });
    });
  });
}
