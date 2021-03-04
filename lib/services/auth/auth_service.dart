import 'dart:async';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebasestarter/models/user.dart';

abstract class AuthService {
  Stream<User> get onAuthStateChanged;
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword({
    String name,
    String lastName,
    String email,
    String password,
  });
  Future<void> sendPasswordResetEmail(String email);
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithApple({List<Scope> scopes});
  Future<void> signOut();
  Future<bool> changeProfile(
      {String firstName, String lastName, String photoURL});
  Future<bool> deleteAccount();
}
