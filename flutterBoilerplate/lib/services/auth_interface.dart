import 'package:flutterBoilerplate/models/domain/user.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

abstract class IAuth {
  Future<User> getCurrentUser();

  Future<User> loginAnonymously();

  Future<User> loginWithEmail(String email, String password);

  Future<User> createAccountWithEmail({
    String firstName,
    String lastName,
    String email,
    String password,
  });

  Future<bool> forgotPassword(String email);

  Future<User> loginWithGoogle();

  Future<User> loginWithFacebook();

  Future<User> loginWithApple({List<Scope> scopes});

  Future<bool> logout();

  Future<User> checkIfUserIsLoggedIn();

  Future<bool> deleteAccount();
}
