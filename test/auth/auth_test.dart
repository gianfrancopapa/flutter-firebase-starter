import 'package:firebasestarter/models/user.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
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

  group('Firebase auth', () {
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

  group('Google Sign in', () {
    test('Success', () async {
      final _googleAuthService = MockGoogleAuthService();
      final authService =
          FirebaseAuthService(auth, googleSignIn, _googleAuthService);
      final _googleAccount = MockGoogleSignInAccount();
      final _googleAuth = MockGoogleSignInAuthentication();
      final credential = Auth.GoogleAuthProvider.credential(
        idToken: 'abcd1234',
        accessToken: 'abcd1234',
      );

      when(_googleAuthService.getGoogleUser(googleSignIn))
          .thenAnswer((_) async => _googleAccount);

      when(_googleAuthService.getGoogleAuth(_googleAccount))
          .thenAnswer((_) async => _googleAuth);

      when(_googleAuth.accessToken).thenReturn('abcd1234');

      when(_googleAuth.idToken).thenReturn('abcd1234');

      when(_googleAuthService.getUserCredentials('abcd1234', 'abcd1234'))
          .thenReturn(credential);

      when(auth.signInWithCredential(credential))
          .thenAnswer((_) async => userCredential);

      final obtainedUser = await authService.signInWithGoogle();
      final obtainedUserJSON = obtainedUser.toJson();

      expect(mapEquals(expectedUserJSON, obtainedUserJSON), true);
    });

    test('Cancelled by user', () async {
      final authService = FirebaseAuthService(auth, googleSignIn);
      when(googleSignIn.signIn()).thenAnswer((realInvocation) => null);

      expect(await authService.signInWithGoogle(), null);
    });

    test('No google auth', () async {
      final authService = FirebaseAuthService(auth, googleSignIn);
      final _googleAccount = MockGoogleSignInAccount();
      final _googleAuth = MockGoogleSignInAuthentication();

      when(googleSignIn.signIn()).thenAnswer((_) async => _googleAccount);

      when(_googleAccount.authentication).thenAnswer((_) async => _googleAuth);

      when(_googleAuth.accessToken).thenReturn(null);

      when(_googleAuth.idToken).thenReturn(null);

      expect(() async => authService.signInWithGoogle(), throwsException);
    });
  });

  group('Facebook sign in', () {
    test('Success', () async {
      final _facebookAuthService = MockFacebookAuthService();
      final _facebook = MockFacebookLogin();
      final authService = FirebaseAuthService(
          auth, null, null, _facebook, _facebookAuthService);
      final loginResult = MockFacebookLoginResult();
      final accessToken = MockFacebookAccessToken();

      when(_facebookAuthService.signIn(_facebook))
          .thenAnswer((realInvocation) async => loginResult);

      when(loginResult.status).thenReturn(FacebookLoginStatus.success);

      when(loginResult.accessToken).thenReturn(accessToken);

      when(accessToken.token).thenReturn('abcd1234');

      final credential = Auth.FacebookAuthProvider.credential('abcd1234');

      when(_facebookAuthService.createFirebaseCredential('abcd1234'))
          .thenReturn(credential);

      when(auth.signInWithCredential(credential))
          .thenAnswer((_) async => userCredential);

      final obtainedUser = await authService.signInWithFacebook();
      final obtainedUserJSON = obtainedUser.toJson();

      expect(mapEquals(expectedUserJSON, obtainedUserJSON), true);
    });

    test('Cancelled by user', () async {
      final _facebookAuthService = MockFacebookAuthService();
      final _facebook = MockFacebookLogin();
      final authService = FirebaseAuthService(
          auth, null, null, _facebook, _facebookAuthService);
      final loginResult = MockFacebookLoginResult();

      when(_facebookAuthService.signIn(_facebook))
          .thenAnswer((realInvocation) async => loginResult);

      when(loginResult.status).thenReturn(FacebookLoginStatus.cancel);

      expect(await authService.signInWithFacebook(), null);
    });

    test('Facebook Error', () async {
      final _facebookAuthService = MockFacebookAuthService();
      final _facebook = MockFacebookLogin();
      final authService = FirebaseAuthService(
          auth, null, null, _facebook, _facebookAuthService);
      final loginResult = MockFacebookLoginResult();

      when(_facebookAuthService.signIn(_facebook))
          .thenAnswer((realInvocation) async => loginResult);

      when(loginResult.status).thenReturn(FacebookLoginStatus.error);

      final error = FacebookError(
          developerMessage: 'error',
          localizedDescription: 'error',
          localizedTitle: 'error');

      when(loginResult.error).thenReturn(error);

      expect(() async => authService.signInWithFacebook(), throwsException);
    });
  });
}
