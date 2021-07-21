import 'package:firebase_auth/firebase_auth.dart';

abstract class ISignInService {
  Future<OAuthCredential> getFirebaseCredential();
  Future<void> signOut();
}
