part of auth;

typedef BuildSignInService = ISignInService? Function();

class SignInServiceFactory {
  SignInServiceFactory();

  final _signInServiceInstances = <AuthenticationMethod, ISignInService?>{};
  final _signInServiceConstructor =
      <AuthenticationMethod, BuildSignInService>{};
  ISignInService? _signInMethod;

  ISignInService? get signInMethod => _signInMethod;

  ISignInService? getService({required AuthenticationMethod method}) {
    if (!_signInServiceInstances.containsKey(method)) {
      _signInServiceInstances[method] = _signInServiceConstructor[method]!();
    }

    _signInMethod = _signInServiceInstances[method];

    return _signInMethod;
  }

  void addService({
    required AuthenticationMethod method,
    required BuildSignInService constructor,
  }) {
    if (!_signInServiceConstructor.containsKey(method)) {
      _signInServiceConstructor[method] = constructor;
    } else {
      throw Exception('Error: The method already exists.');
    }
  }
}
