import 'package:firebasestarter/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_mock.dart';
import './mocks/auth_mocks.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

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

  group('Firebase auth /', () {
    test('Sign in with email and password', () async {
      final authService = FirebaseAuthService(auth);

      when(auth.signInWithEmailAndPassword(
              email: 'email', password: 'password'))
          .thenAnswer((_) async => userCredential);

      final obtainedUser =
          await authService.signInWithEmailAndPassword('email', 'password');

      final obtainedUserJSON = obtainedUser.toJson();

      expect(mapEquals(expectedUserJSON, obtainedUserJSON), true);
    });

    test('Current user', () async {
      final authService = FirebaseAuthService(auth);

      when(auth.currentUser).thenAnswer((_) => MockFirebaseUser());

      final obtainedUser = await authService.currentUser();

      final obtainedUserJSON = obtainedUser.toJson();

      expect(mapEquals(expectedUserJSON, obtainedUserJSON), true);
    });

    test('Anonymous sign in', () async {
      final authService = FirebaseAuthService(auth);

      when(auth.signInAnonymously()).thenAnswer((_) async => userCredential);

      final obtainedUser = await authService.signInAnonymously();

      final obtainedUserJSON = obtainedUser.toJson();

      expect(mapEquals(expectedUserJSON, obtainedUserJSON), true);
    });

    test('Change profile', () async {
      final authService = FirebaseAuthService(auth);
      final user = MockFirebaseUser();

      when(user.updateProfile(
        displayName: 'A Test',
        photoURL: 'URL',
      )).thenAnswer((_) => null);

      final changedProfile = await authService.changeProfile(
          firstName: 'A', lastName: 'Test', photoURL: 'URL');

      expect(changedProfile, true);
    });

    test('Delete account', () async {
      final authService = FirebaseAuthService(auth);
      final user = MockFirebaseUser();

      when(user.delete()).thenAnswer((_) => null);

      final success = await authService.deleteAccount();

      expect(success, true);
    });
  });

  group('Google Sign in /', () {
    test('Success', () async {
      final _googleSignInService = MockGoogleSignInService();
      final authService =
          FirebaseAuthService(auth, testingService: _googleSignInService);
      final credential = Auth.GoogleAuthProvider.credential(
        idToken: 'abcd1234',
        accessToken: 'abcd1234',
      );

      when(_googleSignInService.getFirebaseCredential())
          .thenAnswer((_) async => credential);

      when(auth.signInWithCredential(credential))
          .thenAnswer((_) async => userCredential);

      final obtainedUser = await authService.signInWithGoogle();
      final obtainedUserJSON = obtainedUser.toJson();

      expect(mapEquals(expectedUserJSON, obtainedUserJSON), true);
    });

    test('Cancelled by user', () async {
      final authService = FirebaseAuthService(auth);
      when(googleSignIn.signIn()).thenAnswer((_) => null);

      expect(
          await authService.signInWithGoogle(googleLogin: googleSignIn), null);
    });
  });

  group('Facebook sign in /', () {
    test('Success', () async {
      final _facebookSignInService = MockFacebookSignInService();
      final authService =
          FirebaseAuthService(auth, testingService: _facebookSignInService);

      final credential = Auth.FacebookAuthProvider.credential('abcd1234');

      when(_facebookSignInService.getFirebaseCredential())
          .thenAnswer((_) async => credential);

      when(auth.signInWithCredential(credential))
          .thenAnswer((_) async => userCredential);

      final obtainedUser = await authService.signInWithFacebook();
      final obtainedUserJSON = obtainedUser.toJson();

      expect(mapEquals(expectedUserJSON, obtainedUserJSON), true);
    });

    test('Cancelled by user', () async {
      final _facebookSignInService = MockFacebookSignInService();
      final authService =
          FirebaseAuthService(auth, testingService: _facebookSignInService);

      when(_facebookSignInService.getFirebaseCredential())
          .thenAnswer((_) async => null);

      expect(await authService.signInWithFacebook(), null);
    });
  });

  group('Apple sign in /', () {
    test('Success', () async {
      final _appleSignInService = MockAppleSignInService();
      final authService =
          FirebaseAuthService(auth, testingService: _appleSignInService);

      final credential = Auth.OAuthProvider('apple.com').credential(
        idToken: 'abcd1234',
        rawNonce: 'abcd1234',
      );

      when(_appleSignInService.getFirebaseCredential())
          .thenAnswer((_) async => credential);

      when(auth.signInWithCredential(credential))
          .thenAnswer((_) async => userCredential);

      final obtainedUser = await authService.signInWithApple();
      final obtainedUserJSON = obtainedUser.toJson();

      expect(mapEquals(expectedUserJSON, obtainedUserJSON), true);
    });

    test('Cancelled by user', () async {
      final _appleSignInService = MockAppleSignInService();
      final authService =
          FirebaseAuthService(auth, testingService: _appleSignInService);

      when(_appleSignInService.getFirebaseCredential())
          .thenAnswer((_) async => null);

      expect(await authService.signInWithApple(), null);
    });
  });
}
