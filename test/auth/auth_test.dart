import 'package:firebasestarter/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebaseMock.dart';
import './mocks/auth_mocks.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/foundation.dart';

void main() async {
  setupFirebaseAuthMocks();
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final auth = MockFirebaseAuth();
  final authService = FirebaseAuthService(auth);
  final userData = <String, dynamic>{
    'id': 'abc1234',
    'firstName': 'Test',
    'lastName': 'Name',
    'email': 'email@email.com',
    'emailVerified': true,
    'imageUrl': '',
    'isAnonymous': false,
    'age': 0,
    'phoneNumber': '',
    'address': '',
  };
  final expectedUser = User.fromJson(userData);
  final userCredential = MockUserCredential();

  group('Email and password auth', () {
    test('Sign in with email and password', () async {
      when(auth.signInWithEmailAndPassword(
              email: 'email', password: 'password'))
          .thenAnswer((_) async => userCredential);

      final obtainedUser =
          await authService.signInWithEmailAndPassword('email', 'password');

      final expectedUserJSON = expectedUser.toJson();
      final obtainedUserJSON = obtainedUser.toJson();

      expect(mapEquals(expectedUserJSON, obtainedUserJSON), true);
    });
  });
}
