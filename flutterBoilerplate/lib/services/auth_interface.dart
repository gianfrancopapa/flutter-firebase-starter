import 'package:flutterBoilerplate/models/user.dart';

abstract class IAuth {
  Future<User> createAccountWithEmail({
    String firstName,
    String lastName,
    String email,
    String password,
  });

  Future<User> loginWithEmail(String email, String password);

  Future<User> loginWithPhoneNumber(String smsCode);

  Future<User> checkIfUserIsLoggedIn();

  Future<bool> logout();

  Future<bool> deleteAccount();

  Future<bool> forgotPassword(String email);

  Future<User> getCurrentUser();
}
