import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebasestarter/services/auth/sign_in_services/sign_in_service.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class FacebookSignInService implements SignInService {
  FacebookLogin _facebookServices;

  FacebookSignInService({FacebookLogin signInMethod}) {
    _facebookServices = signInMethod ?? FacebookLogin();
  }

  Future<FacebookLoginResult> _facebookSignIn() {
    return _facebookServices.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
  }

  Auth.OAuthCredential _createFirebaseCredential(String facebookToken) {
    return Auth.FacebookAuthProvider.credential(facebookToken);
  }

  @override
  Future<Auth.OAuthCredential> getFirebaseCredential() async {
    final result = await _facebookSignIn();
    switch (result.status) {
      case FacebookLoginStatus.success:
        final accessToken = result.accessToken.token;
        return _createFirebaseCredential(accessToken);
      case FacebookLoginStatus.cancel:
        return null;
      case FacebookLoginStatus.error:
        throw Auth.FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: result.error.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<void> signOut() async {
    await _facebookServices.logOut();
  }
}
