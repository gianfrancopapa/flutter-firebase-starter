import 'package:firebase_auth_platform_interface/src/providers/oauth.dart';
import 'package:firebasestarter/services/auth/sign_in_services/apple/apple_credentials.dart';
import 'package:firebasestarter/services/auth/sign_in_services/sign_in_service.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class AppleSignInService implements SignInService {
  AppleCredentials _parameterInstance;

  AppleSignInService({AppleCredentials signInMethod}) {
    _parameterInstance = signInMethod;
  }

  AppleCredentials _generateAppleCredentialsInstance() {
    return _parameterInstance ?? AppleCredentials();
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Future<OAuthCredential> getFirebaseCredential({String testingNonce}) async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);
    final credentialsGetter = _generateAppleCredentialsInstance();

    final appleCredential = await credentialsGetter.getAppleCredentials(
      [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      testingNonce ?? nonce,
    );

    final firebaseCredentials = appleCredential != null
        ? Auth.OAuthProvider('apple.com').credential(
            idToken: appleCredential.identityToken,
            rawNonce: testingNonce ?? rawNonce,
          )
        : null;

    return firebaseCredentials;
  }

  @override
  Future<void> signOut() {
    return null;
  }
}
