import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/google/googe_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebaseMock.dart';
import './mocks/auth_mocks.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {
  @override
  String get idToken => 'abc1234';

  @override
  String get accessToken => 'abc1234';
}

class MockGoogleAuthService extends Mock implements GoogleAuthService {}

void main() async {
  setupFirebaseAuthMocks();
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final auth = MockFirebaseAuth();
  final googleSignIn = MockGoogleSignIn();
  final userData = <String, dynamic>{
    'id': 'abc1234',
    'firstName': 'Test',
    'lastName': 'Name',
    'email': 'email@email.com',
    'emailVerified': true,
    'imageUrl': '',
    'isAnonymous': false,
    'age': 0,
    'phoneNumber': '',
    'address': '',
  };
  final expectedUser = User.fromJson(userData);
  final expectedUserJSON = expectedUser.toJson();
  final userCredential = MockUserCredential();

  group('Email and password auth', () {
    test('Sign in with email and password', () async {
      final authService = FirebaseAuthService(auth, googleSignIn);

      when(auth.signInWithEmailAndPassword(
              email: 'email', password: 'password'))
          .thenAnswer((_) async => userCredential);

      final obtainedUser =
          await authService.signInWithEmailAndPassword('email', 'password');

      final obtainedUserJSON = obtainedUser.toJson();

      expect(mapEquals(expectedUserJSON, obtainedUserJSON), true);
    });

    test('Sign in with Google account', () async {
      final _googleAuthService = MockGoogleAuthService();
      final authService =
          FirebaseAuthService(auth, googleSignIn, _googleAuthService);
      final _googleAccount = MockGoogleSignInAccount();
      final _googleAuth = MockGoogleSignInAuthentication();
      final credential = Auth.GoogleAuthProvider.credential(
        idToken: _googleAuth.idToken,
        accessToken: _googleAuth.accessToken,
      );

      when(_googleAuthService.getGoogleUser(googleSignIn))
          .thenAnswer((_) async => _googleAccount);

      when(_googleAuthService.getGoogleAuth(_googleAccount))
          .thenAnswer((_) async => _googleAuth);

      when(_googleAuthService.getUserCredentials(
              _googleAuth.idToken, _googleAuth.accessToken))
          .thenReturn(credential);

      when(auth.signInWithCredential(credential))
          .thenAnswer((_) async => userCredential);

      final obtainedUser = await authService.signInWithGoogle();
      final obtainedUserJSON = obtainedUser.toJson();

      expect(mapEquals(expectedUserJSON, obtainedUserJSON), true);
    });
  });
}
