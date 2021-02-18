abstract class LoginEvent {
  const LoginEvent();
}

class StartLogin extends LoginEvent {
  const StartLogin();
}

class StartGoogleLogin extends LoginEvent {
  const StartGoogleLogin();
}

class StartAppleLogin extends LoginEvent {
  const StartAppleLogin();
}

class StartFacebookLogin extends LoginEvent {
  const StartFacebookLogin();
}

class StartLogout extends LoginEvent {
  const StartLogout();
}

class CheckIfUserIsLoggedIn extends LoginEvent {
  const CheckIfUserIsLoggedIn();
}
