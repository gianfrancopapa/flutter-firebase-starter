part of auth;

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({
    required auth.FirebaseAuth authService,
    required SignInServiceFactory signInServiceFactory,
  })  : _firebaseAuth = authService,
        _signInServiceFactory = signInServiceFactory;

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
  Stream<UserEntity?> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  Future<UserEntity?> currentUser() async {
    return _mapFirebaseUser(_firebaseAuth.currentUser);
  }

  @override
  Future<UserEntity?> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      return _mapFirebaseUser(userCredential.user);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _mapFirebaseUser(userCredential.user);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<UserEntity?> createUserWithEmailAndPassword({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name + ' ' + lastName);
      await userCredential.user!.reload();

      return _mapFirebaseUser(_firebaseAuth.currentUser);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<void>? sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<UserEntity?> signInWithSocialMedia({
    required AuthenticationMethod method,
  }) async {
    try {
      final service = _signInServiceFactory.getService(method: method)!;
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
  Future<void> sendSignInLinkToEmail({required String email}) async {
    try {
      final actionCodeSettings = ActionCodeSettings(
        url: 'https://somnioboilerplate.page.link/',
        androidMinimumVersion: '6',
        androidPackageName: 'com.somniosoftware.firebasestarter',
        iOSBundleId: 'com.somniosoftware.firebasestarter',
        handleCodeInApp: true,
        androidInstallApp: true,
      );

      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<UserEntity?> signInWithEmailLink({email, emailLink}) async {
    try {
      await _firebaseAuth.signInWithEmailLink(
          email: email, emailLink: emailLink);

      return _mapFirebaseUser(_firebaseAuth.currentUser);
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  bool isSignInWithEmailLink({required String emailLink}) {
    return _firebaseAuth.isSignInWithEmailLink(emailLink);
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
  Future<void>? deleteAccount(String password) async {
    try {
      final user = _firebaseAuth.currentUser!;
      auth.AuthCredential credential = auth.EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await user.delete();
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  @override
  Future<void>? deleteAccountSocialMedia(AuthenticationMethod method) async {
    try {
      final service = _signInServiceFactory.getService(method: method)!;
      final firebaseCredential = await service.getFirebaseCredential();
      final user = _firebaseAuth.currentUser!;

      if (firebaseCredential != null) {
        await user.reauthenticateWithCredential(firebaseCredential);
      }

      await user.delete();
    } on auth.FirebaseAuthException catch (e) {
      throw _determineError(e);
    }
  }

  AuthError _determineError(auth.FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return AuthError.invalidEmail;
      case 'user-disabled':
        return AuthError.userDisabled;
      case 'user-not-found':
        return AuthError.userNotFound;
      case 'wrong-password':
        return AuthError.wrongPassword;
      case 'email-already-in-use':
      case 'account-exists-with-different-credential':
        return AuthError.emailAlreadyInUse;
      case 'invalid-credential':
        return AuthError.invalidCredential;
      case 'operation-not-allowed':
        return AuthError.operationNotAllowed;
      case 'weak-password':
        return AuthError.weakPassword;
      case 'invalid-action-code':
        return AuthError.expiredLink;
      case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
      default:
        return AuthError.error;
    }
  }
}
