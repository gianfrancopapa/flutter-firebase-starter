abstract class LoginEvent {
  const LoginEvent();
}

class StartLogin extends LoginEvent {
  const StartLogin();
}

class StartLogout extends LoginEvent {
  const StartLogout();
}

class CheckIfUserIsLoggedIn extends LoginEvent {
  const CheckIfUserIsLoggedIn();
}
