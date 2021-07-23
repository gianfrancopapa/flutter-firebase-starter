import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignInService implements ISignInService {
  FacebookSignInService({
    @required FacebookAuth facebookAuth,
  })  : assert(facebookAuth != null),
        _facebookAuth = facebookAuth;

  final FacebookAuth _facebookAuth;

  Future<LoginResult> _facebookSignIn() async {
    final res = await _facebookAuth.login(
      loginBehavior: LoginBehavior.nativeWithFallback,
    );

    return res;
  }

  Auth.OAuthCredential _createCredential(String facebookToken) {
    return Auth.FacebookAuthProvider.credential(facebookToken);
  }

  @override
  Future<Auth.OAuthCredential> getFirebaseCredential() async {
    try {
      final result = await _facebookSignIn();

      if (result.status == LoginStatus.success) {
        return _createCredential(result.accessToken.token);
      }

      if (result.status == LoginStatus.cancelled) return null;

      throw Auth.FirebaseAuthException(
        code: 'ERROR_FACEBOOK_LOGIN_FAILED',
        message: result.message,
      );
    } on Exception {
      throw Auth.FirebaseAuthException(code: 'ERROR_FACEBOOK_LOGIN_FAILED');
    }
  }

  @override
  Future<void> signOut() async {
    await _facebookAuth.logOut();
  }
}
