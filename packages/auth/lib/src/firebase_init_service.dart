part of auth;

class FirebaseInitService {
  final Map<SocialMediaMethod, ISignInService> _services = {
    SocialMediaMethod.APPLE:
        AppleSignInService(appleCredentials: const AppleCredentials()),
    SocialMediaMethod.FACEBOOK: FacebookSignInService(
      facebookAuth: FacebookAuth.instance,
    ),
    SocialMediaMethod.GOOGLE: GoogleSignInService(
      googleSignIn: GoogleSignIn(),
    ),
  };

  FirebaseAuthService init(List<SocialMediaMethod> socialMediasAuth) {
    final _serviceFactory = SignInServiceFactory();

    socialMediasAuth.forEach((element) {
      if (_services.containsKey(element)) {
        _serviceFactory.addService(
            method: element, constructor: () => _services[element],);
      }
    });

    return FirebaseAuthService(
        authService: FirebaseAuth.instance,
        signInServiceFactory: _serviceFactory,);
  }
}
