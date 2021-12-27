part of auth;

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({
    required auth.FirebaseAuth? authService,
    required SignInServiceFactory? signInServiceFactory,
  })  : assert(authService != null),
        assert(signInServiceFactory != null),
        _firebaseAuth = authService!,
        _signInServiceFactory = signInServiceFactory!;

  final auth.FirebaseAuth _firebaseAuth;
  final SignInServiceFactory _signInServiceFactory;

  UserEntity? _mapFirebaseUser(auth.User? user) {
    if (user == null) {
      return null;
    }
    var splittedName = ['Name ', 'LastName'];
    if (user.displayName != null) {
      splittedName = user.displayName!.split(' ');
    }
    final map = <String, dynamic>{
      'id': user.uid,
      'firstName': splittedName.first,
      'lastName': splittedName.last,
      'email': user.email ?? '',
      'emailVerified': user.emailVerified,
      'imageUrl': user.photoURL ?? '',
      'isAnonymous': user.isAnonymous,
      'age': 0,
      'phoneNumber': '',
      'address': '',
    };
    return UserEntity.fromJson(map);
  }

  @override
  Stream<UserEntity?>? get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  Future<UserEntity?>? currentUser() async {
    return _mapFirebaseUser(_firebaseAuth.currentUser);
  }

  @override
  Future<UserEntity?>? signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      return _mapFirebaseUser(userCredential.user);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<UserEntity?>? signInWithEmailAndPassword({
    required String? email,
    required String? password,
  }) async {
    assert(email != null);
    assert(password != null);

    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      return _mapFirebaseUser(userCredential.user);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<UserEntity?>? createUserWithEmailAndPassword({
    required String? name,
    required String? lastName,
    required String? email,
    required String? password,
  }) async {
    assert(name != null);
    assert(lastName != null);
    assert(email != null);
    assert(password != null);

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      await userCredential.user!.updateDisplayName(name! + ' ' + lastName!);
      await userCredential.user!.reload();

      return _mapFirebaseUser(_firebaseAuth.currentUser);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<void>? sendPasswordResetEmail({required String? email}) async {
    assert(email != null);

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email!);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<UserEntity?>? signInWithSocialMedia({
    required SocialMediaMethod? method,
  }) async {
    assert(method != null);

    try {
      final service = _signInServiceFactory.getService(method: method!)!;
      final firebaseCredential = await service.getFirebaseCredential();

      if (firebaseCredential != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
          firebaseCredential,
        );

        return _mapFirebaseUser(userCredential.user);
      }

      return null;
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<void>? signOut() async {
    try {
      final service = _signInServiceFactory.signInMethod;

      await service?.signOut();
      await _firebaseAuth.signOut();
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<bool>? changeProfile({
    String? firstName,
    String? lastName,
    String? photoURL,
  }) async {
    try {
      final user = _firebaseAuth.currentUser!;
      if (user.displayName != '$firstName $lastName') {
        await user.updateDisplayName('$firstName $lastName');
      }

      if (photoURL != null && photoURL != user.photoURL) {
        await user.updatePhotoURL(photoURL);
      }
      return true;
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<void>? deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser!;
      await user.delete();
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  AuthError _determineError(auth.FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return AuthError.INVALID_EMAIL;
      case 'user-disabled':
        return AuthError.USER_DISABLED;
      case 'user-not-found':
        return AuthError.USER_NOT_FOUND;
      case 'wrong-password':
        return AuthError.WRONG_PASSWORD;
      case 'email-already-in-use':
      case 'account-exists-with-different-credential':
        return AuthError.EMAIL_ALREADY_IN_USE;
      case 'invalid-credential':
        return AuthError.INVALID_CREDENTIAL;
      case 'operation-not-allowed':
        return AuthError.OPERATION_NOT_ALLOWED;
      case 'weak-password':
        return AuthError.WEAK_PASSWORD;
      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
      default:
        return AuthError.ERROR;
    }
  }
}
