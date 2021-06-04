import 'package:firebasestarter/services/auth/sign_in_services/apple/apple_sign_in_service.dart';
import 'package:firebasestarter/services/auth/sign_in_services/facebook/facebook_sign_in_service.dart';
import 'package:firebasestarter/services/auth/sign_in_services/google/googe_sign_in_service.dart';
import 'package:firebasestarter/services/auth/sign_in_services/sign_in_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'sign_in_services/sign_in_service.dart';

class FirebaseAuthService implements AuthService {
  final Auth.FirebaseAuth _firebaseAuth;
  SignInService _signInMethod;
  SignInService _testingService;

  FirebaseAuthService(Auth.FirebaseAuth this._firebaseAuth,
      {SignInService testingService}) {
    _testingService = testingService;
  }

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
    final userCredential = await _firebaseAuth.signInAnonymously();
    return _mapFirebaseUser(userCredential.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _mapFirebaseUser(userCredential.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword({
    String name,
    String lastName,
    String email,
    String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user.updateDisplayName(
        name + ' ' + lastName,
      );
      await userCredential.user.reload();
      return _mapFirebaseUser(_firebaseAuth.currentUser);
    } catch (err) {
      throw err.toString();
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User> _signInWithAService(SignInService service) async {
    final firebaseCredential = await service.getFirebaseCredential();
    if (firebaseCredential != null) {
      final userCredential = await _firebaseAuth.signInWithCredential(
        firebaseCredential,
      );
      _signInMethod = service;
      return _mapFirebaseUser(userCredential.user);
    }
    return null;
  }

  @override
  Future<User> signInWithGoogle({GoogleSignIn googleLogin}) async {
    final googleService =
        _testingService ?? GoogleSignInService(signInMethod: googleLogin);
    return _signInWithAService(googleService);
  }

  @override
  Future<User> signInWithFacebook({FacebookAuth facebookLogin}) async {
    final facebookService =
        _testingService ?? FacebookSignInService(signInMethod: facebookLogin);
    return _signInWithAService(facebookService);
  }

  @override
  Future<User> signInWithApple({AppleSignInService appleLogin}) async {
    final appleService = _testingService ?? AppleSignInService();
    return _signInWithAService(appleService);
  }

  @override
  Future<void> signOut() async {
    await _signInMethod?.signOut();
    _signInMethod = null;
    await _firebaseAuth.signOut();
  }

  @override
  Future<bool> changeProfile(
      {String firstName, String lastName, String photoURL}) async {
    try {
      final user = _firebaseAuth.currentUser;
      await user.updateDisplayName('$firstName $lastName');
      await user.updatePhotoURL(photoURL);
      return true;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      await user.delete();
      return true;
    } catch (e) {
      throw e;
    }
  }
}
