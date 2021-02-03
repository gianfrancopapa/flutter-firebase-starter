import 'package:flutterBoilerplate/models/datatypes/auth_service_type.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class StartLogin extends LoginEvent {
  final AuthServiceType type;
  const StartLogin(this.type);
}

class StartLogout extends LoginEvent {
  const StartLogout();
}

class CheckIfUserIsLoggedIn extends LoginEvent {
  const CheckIfUserIsLoggedIn();
}
