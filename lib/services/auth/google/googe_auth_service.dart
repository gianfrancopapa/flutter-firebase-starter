import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class GoogleAuthService {
  const GoogleAuthService();

  Future<GoogleSignInAccount> getGoogleUser(GoogleSignIn googleSignIn) {
    return googleSignIn.signIn();
  }

  Future<GoogleSignInAuthentication> getGoogleAuth(
      GoogleSignInAccount googleUser) {
    if (googleUser != null) {
      return googleUser.authentication;
    }
    return null;
  }

  Auth.OAuthCredential getUserCredentials(String accessToken, String idToken) {
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
}
