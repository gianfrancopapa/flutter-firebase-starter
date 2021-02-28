import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthService {
  final Auth.FirebaseAuth _firebaseAuth = Auth.FirebaseAuth.instance;

  User _mapFirebaseUser(Auth.User user) {
    if (user == null) {
      return null;
    }
    final map = {
      'id': user.uid,
      'name': user.displayName,
      'email': user.email,
      'emailVerified': user.emailVerified,
      'imageUrl': user.photoURL,
    };
    return User.fromJson(map);
  }

  @override
  Stream<User> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  Future<User> currentUser() async {
    return _mapFirebaseUser(_firebaseAuth.currentUser);
  }

  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return _mapFirebaseUser(userCredential.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapFirebaseUser(userCredential.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapFirebaseUser(userCredential.user);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final userCredential = await _firebaseAuth.signInWithCredential(
            Auth.GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            ),
          );
          return _mapFirebaseUser(userCredential.user);
        } else {
          throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token',
          );
        }
      } else {
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }
    } catch (err) {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'User aborted Google Sign in',
      );
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
          Auth.FacebookAuthProvider.credential(accessToken.token),
        );
        return _mapFirebaseUser(userCredential.user);
      case FacebookLoginStatus.cancel:
        throw Auth.FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Login cancelado pelo usuário.',
        );
      case FacebookLoginStatus.error:
        throw Auth.FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: response.error.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User> signInWithApple({List<Scope> scopes}) async {
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = Auth.OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          final displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(displayName: displayName);
        }
        return _mapFirebaseUser(firebaseUser);
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );
      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    return _firebaseAuth.signOut();
  }

  @override
  Future<bool> changeProfile(
      {String firstName, String lastName, String photoURL}) async {
    try {
      final user = _firebaseAuth.currentUser;
      await user.updateProfile(
          displayName: '$firstName $lastName', photoURL: photoURL);
      return true;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      await user.delete();
      return true;
    } catch (e) {
      throw e;
    }
  }
}
