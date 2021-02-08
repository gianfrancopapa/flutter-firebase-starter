import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterBoilerplate/models/domain/admin.dart';
import 'package:flutterBoilerplate/models/domain/user.dart';
import 'package:flutterBoilerplate/repository/repository.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService implements IAuth {
  final _facebookSignIn = FacebookAuth.instance;

  @override
  Future<User> checkIfUserIsLoggedIn() async {
    try {
      await _facebookSignIn.expressLogin();
      final user = await _facebookSignIn.getUserData();
      return _determineUserRole(user);
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
  Future<User> getCurrentUser() async {
    try {
      final facebookUser = await _facebookSignIn.getUserData();
      return _determineUserRole(facebookUser);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<User> loginWithEmail(String email, String password) async {
    try {
      _facebookSignIn.login();
      final user = await _facebookSignIn.getUserData();
      return _determineUserRole(user);
    } catch (e) {
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          throw ('You have a previous login operation in progress');

        case FacebookAuthErrorCode.CANCELLED:
          throw ('login cancelled');

        case FacebookAuthErrorCode.FAILED:
          throw ('login failed');
        default:
          throw 'ERROR: Invalid operation.';
      }
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _facebookSignIn.logOut();
      return true;
    } catch (e) {
      throw e;
    }
  }

  User _mapFacebookUserToUser(
    user,
    Constructor<User> constructor,
  ) {
    try {
      final splitName = user['name'].split(' ');
      final map = Map<String, dynamic>();
      map['id'] = user['id'];
      map['firstName'] = splitName[0];
      map['lastName'] = splitName[1];
      map['email'] = user['email'];
      map['avatarAsset'] = user['picture']['data']['url'];
      return constructor(map);
    } catch (e) {
      throw e;
    }
  }

  Future<User> _determineUserRole(user) async {
    Constructor constructor = User.fromJson;
    final userData = await FirebaseFirestore.instance
        .collection('administrators')
        .where('user_id', isEqualTo: user['id'])
        .get();
    if (userData.docs.isNotEmpty) {
      constructor = Admin.fromJson;
    }
    return _mapFacebookUserToUser(
      user,
      constructor,
    );
  }
}
