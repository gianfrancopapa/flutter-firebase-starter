import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthApi;
import 'package:flutter/services.dart';
import 'package:flutterBoilerplate/constants/assets.dart';
import 'package:flutterBoilerplate/models/user.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';

class FirebaseAuthService implements IAuth {
  final _auth = FirebaseAuthApi.FirebaseAuth.instance;

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

      await _auth.currentUser.updateProfile(
        displayName: '$firstName $lastName',
      );
      return _mapFirebaseUserToUser(_auth.currentUser);
    } catch (e) {
      print(e.toString());
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
      print(authResult.user);
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
      final firebaseUser = _auth.currentUser;
      return _mapFirebaseUserToUser(firebaseUser);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User> checkIfUserIsLoggedIn() async {
    try {
      final firebaseUser = _auth.currentUser;
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
      final user = _auth.currentUser;
      await user.delete();
      return true;
    } catch (e) {
      throw e;
    }
  }

  @override
  User getCurrentUser() => _mapFirebaseUserToUser(_auth.currentUser);

  User _mapFirebaseUserToUser(FirebaseAuthApi.User user) {
    try {
      final splitName = user.displayName != null
          ? user.displayName.split(' ')
          : ['Name', 'LastName'];
      final map = Map<String, dynamic>();
      map['id'] = user.uid;
      map['firstName'] = splitName[0];
      map['lastName'] = splitName[1];
      map['email'] = user.email;
      map['avatar'] =
          user.photoURL != null ? File(user.photoURL) : File(AppAsset.anonUser);
      return User.fromJson(map);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
