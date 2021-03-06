abstract class LoginEvent {
  const LoginEvent();
}

class LoginStarted extends LoginEvent {
  const LoginStarted();
}

class GoogleLoginStarted extends LoginEvent {
  const GoogleLoginStarted();
}

class AppleLoginStarted extends LoginEvent {
  const AppleLoginStarted();
}

class FacebookLoginStarted extends LoginEvent {
  const FacebookLoginStarted();
}

class AnonymousLoginStarted extends LoginEvent {
  const AnonymousLoginStarted();
}

class LogoutStarted extends LoginEvent {
  const LogoutStarted();
}

class IsUserLoggedIn extends LoginEvent {
  const IsUserLoggedIn();
}
