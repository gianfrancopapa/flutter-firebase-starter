import 'package:flutterBoilerplate/models/domain/user.dart';

abstract class IAuth {
  Future<User> createAccountWithEmail({
    String firstName,
    String lastName,
    String email,
    String password,
  });

  Future<User> loginWithEmail(String email, String password);

  Future<User> checkIfUserIsLoggedIn();

  Future<bool> logout();

  Future<bool> deleteAccount();

  Future<bool> forgotPassword(String email);

  Future<User> getCurrentUser();

  Future<bool> checkIfEmailIsVerified();
}
