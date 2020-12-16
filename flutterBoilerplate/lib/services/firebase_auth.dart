import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutterBoilerplate/models/user.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';

class FirebaseAuthService implements IAuth {
  final _auth = FirebaseAuth.instance;

  @override
  Future<User> createAccountWithEmail({
    String firstName,
    String lastName,
    String email,
    String password,
  }) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userInfo = UserUpdateInfo();
      userInfo.displayName = '$firstName $lastName';
      await authResult.user.updateProfile(userInfo);
      final firebaseUserUpdated = await _auth.currentUser();
      return _mapFirebaseUserToUser(firebaseUserUpdated);
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
      final authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUserToUser(authResult.user);
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
  Future<User> loginWithPhoneNumber(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: null,
        verificationCompleted: null,
        verificationFailed: null,
        codeSent: null,
        codeAutoRetrievalTimeout: null,
      );
      final firebaseUser = await _auth.currentUser();
      return _mapFirebaseUserToUser(firebaseUser);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User> checkIfUserIsLoggedIn() async {
    try {
      final firebaseUser = await _auth.currentUser();
      if (firebaseUser != null) {
        return _mapFirebaseUserToUser(firebaseUser);
      } else
        return null;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> deleteAccount() async {
    try {
      final user = await _auth.currentUser();
      await user.delete();
      return true;
    } catch (e) {
      throw e;
    }
  }

  User _mapFirebaseUserToUser(FirebaseUser user) {
    try {
      final splitName = user.displayName.split(" ");
      final map = Map<String, dynamic>();
      map['id'] = user.uid;
      map['firstName'] = splitName[0];
      map['lastName'] = splitName[1];
      map['email'] = user.email;
      return User.fromJson(map);
    } catch (e) {
      throw e;
    }
  }
}
