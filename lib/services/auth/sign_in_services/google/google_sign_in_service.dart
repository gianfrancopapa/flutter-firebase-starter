import 'package:firebasestarter/services/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class GoogleSignInService implements ISignInService {
  GoogleSignInService({@required GoogleSignIn googleSignIn})
      : assert(googleSignIn != null),
        _googleSignIn = googleSignIn;

  final GoogleSignIn _googleSignIn;

  Future<GoogleSignInAccount> _getGoogleUser() async {
    final result = await _googleSignIn.signIn();
    return result;
  }

  Future<GoogleSignInAuthentication> _getGoogleAuth(
    GoogleSignInAccount googleUser,
  ) async {
    if (googleUser != null) {
      final result = await googleUser.authentication;
      return result;
    }

    return null;
  }

  Auth.OAuthCredential _getUserCredentials(String accessToken, String idToken) {
    if (accessToken != null || idToken != null) {
      final credential = Auth.GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );
      return credential;
    } else {
      throw Auth.FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
        message: 'Missing Google Auth Token',
      );
    }
  }

  @override
  Future<Auth.OAuthCredential> getFirebaseCredential() async {
    try {
      final googleUser = await _getGoogleUser();

      final googleAuth = await _getGoogleAuth(googleUser);

      if (googleAuth != null) {
        return _getUserCredentials(googleAuth.accessToken, googleAuth.idToken);
      }

      return null;
    } on Exception {
      throw Auth.FirebaseAuthException(code: 'ERROR_GOOGLE_LOGIN');
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
