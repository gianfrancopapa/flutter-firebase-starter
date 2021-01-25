import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutterBoilerplate/repository/repository.dart';
import 'package:flutterBoilerplate/models/domain/admin.dart';
import 'package:flutterBoilerplate/models/domain/user.dart';

class GoogleAuthService implements IAuth {
  final _googleSignIn = GoogleSignIn();

  @override
  Future<User> loginWithEmail(String email, String password) async {
    try {
      final user = await _googleSignIn.signIn();
      return _determineUserRole(user);
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
      await _googleSignIn.signOut();
      return true;
    } catch (e) {
      throw e;
    }
  }

  User _mapGoogleUserToUser(
    user,
    Constructor<User> constructor,
  ) {
    try {
      final splitName = user.displayName.split(' ');
      final map = Map<String, dynamic>();
      map['id'] = user.id;
      map['firstName'] = splitName[0];
      map['lastName'] = splitName[1];
      map['email'] = user.email;
      map['avatarAsset'] = user.photoUrl;
      return constructor(map);
    } catch (e) {
      throw e;
    }
  }

  Future<User> _determineUserRole(user) async {
    Constructor constructor = User.fromJson;
    final userData = await FirebaseFirestore.instance
        .collection('administrators')
        .where('user_id', isEqualTo: user.id)
        .get();
    if (userData.docs.isNotEmpty) {
      constructor = Admin.fromJson;
    }
    return _mapGoogleUserToUser(
      user,
      constructor,
    );
  }

  @override
  Future<User> checkIfUserIsLoggedIn() {
    try {
      final googleUser = _googleSignIn.signInSilently();
      if (googleUser != null) {
        //final googleUser = _googleSignIn.currentUser;
        return _determineUserRole(googleUser);
      } else
        return null;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User> createAccountWithEmail(
      {String firstName, String lastName, String email, String password}) {
    // TODO: implement createAccountWithEmail
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<bool> forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<User> getCurrentUser() {
    try {
      final googleUser = _googleSignIn.currentUser;
      return _determineUserRole(googleUser);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User> loginWithPhoneNumber(String smsCode) {
    // TODO: implement loginWithPhoneNumber
    throw UnimplementedError();
  }
}
