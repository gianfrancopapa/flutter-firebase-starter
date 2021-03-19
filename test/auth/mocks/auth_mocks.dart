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
