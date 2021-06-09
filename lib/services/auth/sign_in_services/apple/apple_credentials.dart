import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleCredentials {
  Future<AuthorizationCredentialAppleID> getAppleCredentials(
      List<AppleIDAuthorizationScopes> scopes, String nonce) async {
    return SignInWithApple.getAppleIDCredential(
      scopes: scopes,
      nonce: nonce,
    );
  }
}
