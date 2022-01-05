import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth/auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'facebook_sign_in_service_test.mocks.dart';

@GenerateMocks(
  [FacebookAuth, AccessToken, LoginResult],
)
void main() {
  group('FacebookSignInService', () {
    FacebookAuth? mockFacebookAuth;
    LoginResult? mockLoginResult;
    AccessToken? mockAccessToken;

    late FacebookSignInService? subject;

    setUp(() {
      mockFacebookAuth = MockFacebookAuth();
      mockLoginResult = MockLoginResult();
      mockAccessToken = MockAccessToken();

      subject = FacebookSignInService(facebookAuth: mockFacebookAuth!);

      when(mockLoginResult!.accessToken).thenReturn(mockAccessToken!);

      when(mockAccessToken!.token).thenReturn('token');
    });

    group('.getFirebaseCredential', () {
      test('completes when LoginStatus.success', () {
        when(mockLoginResult!.status).thenReturn(LoginStatus.success);

        when(
          mockFacebookAuth!
              .login(loginBehavior: LoginBehavior.nativeWithFallback),
        ).thenAnswer(((_) async => mockLoginResult!));

        expect(subject!.getFirebaseCredential(), completes);
      });

      test('completes when LoginStatus.failed', () {
        when(mockLoginResult!.status).thenReturn(LoginStatus.cancelled);

        when(
          mockFacebookAuth!
              .login(loginBehavior: LoginBehavior.nativeWithFallback),
        ).thenAnswer(((_) async => mockLoginResult!));

        expect(subject!.getFirebaseCredential(), completes);
      });

      test('throws when LoginStatus.failed', () {
        when(mockLoginResult!.status).thenReturn(LoginStatus.failed);
        when(
          mockFacebookAuth!
              .login(loginBehavior: LoginBehavior.nativeWithFallback),
        ).thenThrow(FirebaseAuthException(code: ''));
        expect(
          subject!.getFirebaseCredential(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('throws when facebookAuth.login throws', () {
        when(
          mockFacebookAuth!
              .login(loginBehavior: LoginBehavior.nativeWithFallback),
        ).thenThrow(FirebaseAuthException(code: ''));

        expect(
          subject!.getFirebaseCredential(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('.signOut', () {
      test('calls facebookAuth.logOut', () async {
        await subject!.signOut();

        verify(mockFacebookAuth!.logOut());
      });

      test('completes', () async {
        expect(subject!.signOut(), completes);
      });
    });
  });
}
