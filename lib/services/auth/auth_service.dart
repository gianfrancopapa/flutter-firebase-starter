import 'dart:async';
import 'package:firebasestarter/models/user.dart';
import 'package:flutter/foundation.dart';

enum SocialMediaMethod { GOOGLE, FACEBOOK, APPLE }

abstract class AuthService {
  Stream<User> get onAuthStateChanged;

  Future<User> currentUser();

  Future<User> signInAnonymously();

  Future<User> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  });

  Future<User> createUserWithEmailAndPassword({
    @required String name,
    @required String lastName,
    @required String email,
    @required String password,
  });

  Future<void> sendPasswordResetEmail({@required String email});

  Future<User> signInWithSocialMedia({@required SocialMediaMethod method});

  Future<void> signOut();

  Future<bool> changeProfile({
    String firstName,
    String lastName,
    String photoURL,
  });

  Future<void> deleteAccount();
}
