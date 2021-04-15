import 'package:firebasestarter/services/auth/facebook/facebook_auth_service.dart';
import 'package:firebasestarter/services/auth/google/googe_auth_service.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';

class MockFirebaseAuth extends Mock implements Auth.FirebaseAuth {}

class MockAuthService extends Mock implements AuthService {}

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}

class MockFirebaseUser extends Mock implements Auth.User {
  @override
  String get displayName => 'Test Name';

  @override
  String get uid => 'abc1234';

  @override
  String get email => 'email@email.com';

  @override
  bool get emailVerified => true;

  @override
  String get photoURL => '';

  @override
  bool get isAnonymous => false;
}

class MockUserCredential extends Mock implements Auth.UserCredential {
  @override
  Auth.User get user => MockFirebaseUser();
}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

class MockGoogleAuthService extends Mock implements GoogleAuthService {}

class MockFacebookLogin extends Mock implements FacebookLogin {}

class MockFacebookLoginResult extends Mock implements FacebookLoginResult {}

class MockFacebookAccessToken extends Mock implements FacebookAccessToken {}

class MockFacebookAuthService extends Mock implements FacebookAuthService {}
