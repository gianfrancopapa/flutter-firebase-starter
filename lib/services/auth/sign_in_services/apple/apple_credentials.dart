import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleCredentials {
  const AppleCredentials();

  Future<AuthorizationCredentialAppleID> getAppleCredentials({
    @required List<AppleIDAuthorizationScopes> scopes,
    @required String token,
  }) async {
    assert(scopes != null);
    assert(token != null);

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: scopes,
        nonce: token,
      );

      return credential;
    } on Exception {
      throw Exception('ERROR_APPLE_ID_CREDENTIAL');
    }
  }
}
