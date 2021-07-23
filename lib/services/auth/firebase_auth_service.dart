import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({
    @required Auth.FirebaseAuth authService,
    @required SignInServiceFactory signInServiceFactory,
  })  : assert(authService != null),
        assert(signInServiceFactory != null),
        _firebaseAuth = authService,
        _signInServiceFactory = signInServiceFactory;

  final Auth.FirebaseAuth _firebaseAuth;
  final SignInServiceFactory _signInServiceFactory;

  User _mapFirebaseUser(Auth.User user) {
    if (user == null) {
      return null;
    }
    var splittedName = ['Name ', 'LastName'];
    if (user.displayName != null) {
      splittedName = user.displayName.split(' ');
    }
    final map = <String, dynamic>{
      'id': user.uid ?? '',
      'firstName': splittedName.first ?? '',
      'lastName': splittedName.last ?? '',
      'email': user.email ?? '',
      'emailVerified': user.emailVerified ?? false,
      'imageUrl': user.photoURL ?? '',
      'isAnonymous': user.isAnonymous,
      'age': 0,
      'phoneNumber': '',
      'address': '',
    };
    return User.fromJson(map);
  }

  @override
  Stream<User> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  Future<User> currentUser() async {
    return _mapFirebaseUser(_firebaseAuth.currentUser);
  }

  @override
  Future<User> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      return _mapFirebaseUser(userCredential.user);
    } on Auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<User> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null);
    assert(password != null);

    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _mapFirebaseUser(userCredential.user);
    } on Auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword({
    @required String name,
    @required String lastName,
    @required String email,
    @required String password,
  }) async {
    assert(name != null);
    assert(lastName != null);
    assert(email != null);
    assert(password != null);

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user.updateDisplayName(name + ' ' + lastName);
      await userCredential.user.reload();

      return _mapFirebaseUser(_firebaseAuth.currentUser);
    } on Auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({@required String email}) async {
    assert(email != null);

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on Auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<User> signInWithSocialMedia({
    @required SocialMediaMethod method,
  }) async {
    assert(method != null);

    try {
      final service = _signInServiceFactory.getService(method: method);
      final firebaseCredential = await service.getFirebaseCredential();

      if (firebaseCredential != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
          firebaseCredential,
        );

        return _mapFirebaseUser(userCredential.user);
      }

      return null;
    } on Auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      final service = _signInServiceFactory.signInMethod;

      await service?.signOut();
      await _firebaseAuth.signOut();
    } on Auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<bool> changeProfile({
    @required String firstName,
    @required String lastName,
    @required String photoURL,
  }) async {
    assert(firstName != null);
    assert(lastName != null);
    assert(photoURL != null);

    try {
      final user = _firebaseAuth.currentUser;
      await user.updateDisplayName('$firstName $lastName');
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }
      return true;
    } on Auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      await user.delete();
    } on Auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  AuthError _determineError(Auth.FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return AuthError.INVALID_EMAIL;
      case 'user-disabled':
        return AuthError.USER_DISABLED;
      case 'user-not-found':
        return AuthError.USER_NOT_FOUND;
      case 'wrong-password':
        return AuthError.WRONG_PASSWORD;
      case 'email-already-in-use':
      case 'account-exists-with-different-credential':
        return AuthError.EMAIL_ALREADY_IN_USE;
      case 'invalid-credential':
        return AuthError.INVALID_CREDENTIAL;
      case 'operation-not-allowed':
        return AuthError.OPERATION_NOT_ALLOWED;
      case 'weak-password':
        return AuthError.WEAK_PASSWORD;
      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
      default:
        return AuthError.ERROR;
    }
  }
}
