import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebasestarter/services/auth/sign_in_services/sign_in_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignInService implements SignInService {
  FacebookAuth _facebookServices;

  FacebookSignInService({FacebookAuth signInMethod}) {
    _facebookServices = signInMethod ?? FacebookAuth.instance;
  }

  Future<LoginResult> _facebookSignIn() {
    return _facebookServices.login(
        loginBehavior: LoginBehavior.nativeWithFallback);
  }

  Auth.OAuthCredential _createFirebaseCredential(String facebookToken) {
    return Auth.FacebookAuthProvider.credential(facebookToken);
  }

  @override
  Future<Auth.OAuthCredential> getFirebaseCredential() async {
    final result = await _facebookSignIn();
    switch (result.status) {
      case LoginStatus.success:
        final accessToken = result.accessToken.token;
        return _createFirebaseCredential(accessToken);
      case LoginStatus.cancelled:
        return null;
      case LoginStatus.failed:
        throw Auth.FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: result.message,
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
