import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as AuthService;
import 'package:flutterBoilerplate/models/domain/admin.dart';
import 'package:flutterBoilerplate/models/domain/user.dart';
import 'package:flutterBoilerplate/repository/repository.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';

//Singleton
class FirebaseAuthService implements IAuth {
  final _auth = AuthService.FirebaseAuth.instance;

  static final FirebaseAuthService _instance = FirebaseAuthService._internal();

  factory FirebaseAuthService() => _instance;

  FirebaseAuthService._internal();

  @override
  Future<User> createAccountWithEmail({
    String firstName,
    String lastName,
    String email,
    String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _auth.currentUser
          .updateProfile(displayName: '$firstName $lastName');
      final firebaseUserUpdated = _auth.currentUser;
      await firebaseUserUpdated.sendEmailVerification();
      return _determineUserRole(firebaseUserUpdated);
    } catch (e) {
      switch ((e as PlatformException).code) {
        case 'ERROR_WEAK_PASSWORD':
          throw 'ERROR: Weak password';
          break;
        case 'ERROR_INVALID_EMAIL':
          throw 'ERROR: Invalid email';
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          throw 'ERROR: An account with the inserted email already exists.';
          break;
        default:
          throw 'ERROR';
      }
    }
  }

  @override
  Future<User> loginWithEmail(String email, String password) async {
    try {
      final emailVerified = await _checkIfEmailIsVerified();

      if (!emailVerified) {
        throw Error;
      }
      final authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _determineUserRole(authResult.user);
    } catch (e) {
      switch ((e as PlatformException).code) {
        case 'ERROR_INVALID_EMAIL':
        case 'ERROR_WRONG_PASSWORD':
          throw 'ERROR: Invalid credentials.';
        case 'ERROR_USER_DISABLED':
          throw 'ERROR: User is disabled.';
        case 'ERROR_TOO_MANY_REQUESTS':
          throw 'ERROR: Too many requests. Try again in a few minutes.';
        default:
          throw 'ERROR: Invalid operation.';
      }
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User> checkIfUserIsLoggedIn() async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        return _determineUserRole(firebaseUser);
      } else
        return null;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> _checkIfEmailIsVerified() async {
    final emailVerified = _auth.currentUser.emailVerified;
    await _auth.currentUser.reload();
    return emailVerified;
  }

  @override
  Future<bool> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      await user.delete();
      return true;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> changeProfile(
      {String firstName, String lastName, String photoURL}) async {
    try {
      final user = _auth.currentUser;
      await user.updateProfile(
          displayName: '$firstName $lastName', photoURL: photoURL);
      return true;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final firebaseUser = _auth.currentUser;
      return _determineUserRole(firebaseUser);
    } catch (e) {
      throw e;
    }
  }

  Future<User> _determineUserRole(AuthService.User firebaseUser) async {
    Constructor constructor = User.fromJson;
    final userData = await FirebaseFirestore.instance
        .collection('administrators')
        .where('user_id', isEqualTo: firebaseUser.uid)
        .get();
    if (userData.docs.isNotEmpty) {
      constructor = Admin.fromJson;
    }
    return _mapFirebaseUserToUser(
      firebaseUser,
      constructor,
    );
  }

  User _mapFirebaseUserToUser(
    AuthService.User user,
    Constructor<User> constructor,
  ) {
    try {
      final splitName = user.displayName.split(' ');
      final map = Map<String, dynamic>();
      map['id'] = user.uid;
      map['firstName'] = splitName[0];
      map['lastName'] = splitName[1];
      map['email'] = user.email;
      map['avatarAsset'] = user.photoURL;
      return constructor(map);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      throw e;
    }
  }
}
