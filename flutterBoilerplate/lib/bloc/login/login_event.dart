import 'package:flutterBoilerplate/models/datatypes/auth_service_type.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class StartLogin extends LoginEvent {
  final AuthServiceType type;
  const StartLogin(this.type);
}

class StartLogout extends LoginEvent {
  final AuthServiceType type;
  const StartLogout(this.type);
}

class CheckIfUserIsLoggedIn extends LoginEvent {
  final AuthServiceType type;
  const CheckIfUserIsLoggedIn(this.type);
}
