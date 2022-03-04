part of auth;

enum AuthenticationMethod { google, facebook, apple, email, none }

abstract class AuthService {
  Stream<UserEntity?> get onAuthStateChanged;

  Future<UserEntity?> currentUser();

  Future<UserEntity?> signInAnonymously();

  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity?> createUserWithEmailAndPassword({
    required String name,
    required String lastName,
    required String email,
    required String password,
  });

  Future<void>? sendPasswordResetEmail({required String email});

  Future<UserEntity?> signInWithSocialMedia({
    required AuthenticationMethod method,
  });

  Future<void> sendSignInLinkToEmail({required String email});

  Future<UserEntity?> signInWithEmailLink({required email, required emailLink});

  bool isSignInWithEmailLink({required String emailLink});

  Future<void>? signOut();

  Future<bool>? changeProfile({
    String? firstName,
    String? lastName,
    String? photoURL,
  });

  Future<void>? deleteAccountEmail(String password);

  Future<void>? deleteAccountSocialMedia(AuthenticationMethod method);
}
