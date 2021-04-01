import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class FacebookAuthService {
  const FacebookAuthService();

  Future<FacebookLoginResult> signIn(FacebookLogin signInMethod) {
    return signInMethod.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
  }

  Auth.OAuthCredential createFirebaseCredential(String facebookToken) {
    return Auth.FacebookAuthProvider.credential(facebookToken);
  }
}
