import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mockito/mockito.dart';
import 'google_sign_in_service_test.mocks.dart';

// This is created because GoogleSignIn overrides a method that contains dynamic instead of Object?
// Please also add *with LeagacyEquality* in the generated file!
mixin LegacyEquality {
  @override
  bool operator ==(Object? other) => throw UnimplementedError();

  @override
  int get hashCode => throw UnimplementedError();
}
@GenerateMocks(
  [GoogleSignInAccount, GoogleSignInAuthentication, GoogleSignIn],
)
void main() {
  group('GoogleSignInService', () {
    GoogleSignIn? mockGoogleSignIn;
    GoogleSignInAccount? mockGoogleSignInAccount;
    GoogleSignInAuthentication mockGoogleSignInAuthentication;

    late GoogleSignInService subject;

    setUp(() {
      mockGoogleSignIn = MockGoogleSignIn();
      mockGoogleSignInAccount = MockGoogleSignInAccount();
      mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();

      subject = GoogleSignInService(googleSignIn: mockGoogleSignIn!);

      when(mockGoogleSignIn!.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);

      when(mockGoogleSignInAccount!.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);

      when(mockGoogleSignInAuthentication.idToken).thenReturn('idToken');
      when(mockGoogleSignInAuthentication.accessToken)
          .thenReturn('accessToken');
      when(mockGoogleSignIn!.signOut())
          .thenAnswer((_) async => mockGoogleSignInAccount);
    });

    group('.getFirebaseCredential', () {
      test('completes', () {
        expect(subject.getFirebaseCredential(), completes);
      });

      test('fails when googleSignIn.signIn throws', () {
        when(mockGoogleSignIn!.signIn()).thenThrow(Exception());

        expect(
          subject.getFirebaseCredential(),
          throwsA(
            isA<auth.FirebaseAuthException>(),
          ),
        );
      });

      test('fails when googleSignInAccount.authentication throws', () {
        when(mockGoogleSignInAccount!.authentication).thenThrow(Exception());

        expect(
          subject.getFirebaseCredential(),
          throwsA(
            isA<auth.FirebaseAuthException>(),
          ),
        );
      });
    });

    group('.signOut', () {
      test('calls ', () async {
        await subject.signOut();
        verify(mockGoogleSignIn!.signOut()).called(1);
      });

      test('completes', () {
        expect(subject.signOut(), completes);
      });
    });
  });
}
