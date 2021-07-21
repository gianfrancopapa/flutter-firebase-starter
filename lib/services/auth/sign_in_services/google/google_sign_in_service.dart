import 'package:firebasestarter/services/auth/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class GoogleSignInService implements ISignInService {
  GoogleSignIn _parameterInstance;

  GoogleSignInService({GoogleSignIn signInMethod}) {
    _parameterInstance = signInMethod;
  }

  GoogleSignIn _generateGoogleSignInInstance() {
    return _parameterInstance ?? GoogleSignIn();
  }

  Future<GoogleSignInAccount> _getGoogleUser() {
    final googleSignIn = _generateGoogleSignInInstance();
    return googleSignIn.signIn();
  }

  Future<GoogleSignInAuthentication> _getGoogleAuth(
      GoogleSignInAccount googleUser) {
    if (googleUser != null) {
      return googleUser.authentication;
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
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = _generateGoogleSignInInstance();
    await googleSignIn.signOut();
  }
}
