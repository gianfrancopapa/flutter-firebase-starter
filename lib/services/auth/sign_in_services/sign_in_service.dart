import 'package:firebase_auth/firebase_auth.dart';

abstract class SignInService {
  Future<OAuthCredential> getFirebaseCredential();
  Future<void> signOut();
}
