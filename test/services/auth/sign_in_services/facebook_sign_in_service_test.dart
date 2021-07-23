import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFacebookAuth extends Mock implements FacebookAuth {}

class MockLoginResult extends Mock implements LoginResult {}

class MockAccessToken extends Mock implements AccessToken {}

void main() {
  group('FacebookSignInService', () {
    FacebookAuth mockFacebookAuth;
    LoginResult mockLoginResult;
    AccessToken mockAccessToken;

    FacebookSignInService subject;

    setUp(() {
      mockFacebookAuth = MockFacebookAuth();
      mockLoginResult = MockLoginResult();
      mockAccessToken = MockAccessToken();

      subject = FacebookSignInService(facebookAuth: mockFacebookAuth);

      when(mockLoginResult.accessToken).thenReturn(mockAccessToken);

      when(mockAccessToken.token).thenReturn('token');
    });

    test('throwsAssertionError when facebookAuth is null', () {
      expect(
        () => FacebookSignInService(facebookAuth: null),
        throwsAssertionError,
      );
    });

    group('.getFirebaseCredential', () {
      test('completes when LoginStatus.success', () {
        when(mockLoginResult.status).thenReturn(LoginStatus.success);

        when(
          mockFacebookAuth.login(
              loginBehavior: LoginBehavior.nativeWithFallback),
        ).thenAnswer((_) async => mockLoginResult);

        expect(subject.getFirebaseCredential(), completes);
      });

      test('completes when LoginStatus.failed', () {
        when(mockLoginResult.status).thenReturn(LoginStatus.cancelled);

        when(
          mockFacebookAuth.login(
              loginBehavior: LoginBehavior.nativeWithFallback),
        ).thenAnswer((_) async => mockLoginResult);

        expect(subject.getFirebaseCredential(), completes);
      });

      test('throws when LoginStatus.failed', () {
        when(mockLoginResult.status).thenReturn(LoginStatus.failed);

        when(
          mockFacebookAuth.login(
              loginBehavior: LoginBehavior.nativeWithFallback),
        ).thenAnswer((_) async => mockLoginResult);

        expect(
          subject.getFirebaseCredential(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('throws when facebookAuth.login throws', () {
        when(
          mockFacebookAuth.login(
              loginBehavior: LoginBehavior.nativeWithFallback),
        ).thenThrow(FirebaseAuthException(code: ''));

        expect(
          subject.getFirebaseCredential(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('.signOut', () {
      test('calls facebookAuth.logOut', () async {
        await subject.signOut();

        verify(mockFacebookAuth.logOut());
      });

      test('completes', () async {
        expect(subject.signOut(), completes);
      });
    });
  });
}
