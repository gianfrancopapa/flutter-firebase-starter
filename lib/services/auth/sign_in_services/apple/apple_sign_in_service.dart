import 'package:firebase_auth_platform_interface/src/providers/oauth.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

import '../../auth.dart';
import 'apple_credentials.dart';

class AppleSignInService implements ISignInService {
  AppleSignInService({@required AppleCredentials appleCredentials})
      : assert(appleCredentials != null),
        _appleCredentials = appleCredentials;

  static const _charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  static const _authProvider = 'apple.com';

  final AppleCredentials _appleCredentials;

  /// Generates a random token
  String _generateRawRandomToken([int length = 32]) {
    final random = Random.secure();

    return List.generate(
      length,
      (_) => _charset[random.nextInt(_charset.length)],
    ).join();
  }

  /// Encrypts the token
  String _rawTokenToSha256({@required String rawToken}) {
    assert(rawToken != null);

    final bytes = utf8.encode(rawToken);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Creates a Firebase credential
  Auth.OAuthCredential _createCredential({
    @required idToken,
    @required rawToken,
  }) {
    assert(idToken != null);
    assert(rawToken != null);

    return Auth.OAuthProvider(_authProvider).credential(
      idToken: idToken,
      rawNonce: rawToken,
    );
  }

  @override
  Future<OAuthCredential> getFirebaseCredential() async {
    final rawToken = _generateRawRandomToken();
    final token = _rawTokenToSha256(rawToken: rawToken);

    try {
      final appleCredential = await _appleCredentials.getAppleCredentials(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        token: token,
      );

      return _createCredential(
        idToken: appleCredential.identityToken,
        rawToken: rawToken,
      );
    } on Exception {
      throw Auth.FirebaseAuthException(code: 'ERROR_APPLE_LOGIN');
    }
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 1));
  }
}
