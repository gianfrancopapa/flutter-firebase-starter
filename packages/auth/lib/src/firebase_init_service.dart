part of auth;

class FirebaseInitService {
  final Map<AuthenticationMethod, ISignInService> _services = {
    AuthenticationMethod.apple: AppleSignInService(
      appleCredentials: const AppleCredentials(),
    ),
    AuthenticationMethod.facebook: FacebookSignInService(
      facebookAuth: FacebookAuth.instance,
    ),
    AuthenticationMethod.google: GoogleSignInService(
      googleSignIn: GoogleSignIn(),
    ),
  };

  FirebaseAuthService init(List<AuthenticationMethod> socialMediasAuth) {
    final _serviceFactory = SignInServiceFactory();

    for (var element in socialMediasAuth) {
      if (_services.containsKey(element)) {
        _serviceFactory.addService(
          method: element,
          constructor: () => _services[element],
        );
      }
    }

    return FirebaseAuthService(
      authService: FirebaseAuth.instance,
      signInServiceFactory: _serviceFactory,
    );
  }
}
