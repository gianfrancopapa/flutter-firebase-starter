import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

void main() {
  group('GoogleSignInService', () {
    GoogleSignIn mockGoogleSignIn;
    GoogleSignInAccount mockGoogleSignInAccount;
    GoogleSignInAuthentication mockGoogleSignInAuthentication;

    GoogleSignInService subject;

    setUp(() {
      mockGoogleSignIn = MockGoogleSignIn();
      mockGoogleSignInAccount = MockGoogleSignInAccount();
      mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();

      subject = GoogleSignInService(googleSignIn: mockGoogleSignIn);

      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);

      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);

      when(mockGoogleSignInAuthentication.idToken).thenReturn('idToken');
      when(mockGoogleSignInAuthentication.accessToken)
          .thenReturn('accessToken');
    });

    test('throwsAssertionError when googleSignIn is null', () {
      expect(
        () => GoogleSignInService(googleSignIn: null),
        throwsAssertionError,
      );
    });

    group('.getFirebaseCredential', () {
      test('completes', () {
        expect(subject.getFirebaseCredential(), completes);
      });

      test('fails when googleSignIn.signIn throws', () {
        when(mockGoogleSignIn.signIn()).thenThrow(Exception());

        expect(
          subject.getFirebaseCredential(),
          throwsA(
            isA<FirebaseAuthException>(),
          ),
        );
      });

      test('fails when googleSignInAccount.authentication throws', () {
        when(mockGoogleSignInAccount.authentication).thenThrow(Exception());

        expect(
          subject.getFirebaseCredential(),
          throwsA(
            isA<FirebaseAuthException>(),
          ),
        );
      });
    });

    group('.signOut', () {
      test('calls ', () async {
        await subject.signOut();

        verify(mockGoogleSignIn.signOut()).called(1);
      });

      test('completes', () {
        expect(subject.signOut(), completes);
      });
    });
  });
}
