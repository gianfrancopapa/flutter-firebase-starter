abstract class FirstTimeInAppState {
  const FirstTimeInAppState();
}

class FirstTime extends FirstTimeInAppState {
  const FirstTime();
}

class NoFirstTime extends FirstTimeInAppState {
  const NoFirstTime();
}

class Error extends FirstTimeInAppState {
  final String message;
  const Error(this.message);
}

class Loading extends FirstTimeInAppState {
  const Loading();
}

class NotDetermined extends FirstTimeInAppState {
  const NotDetermined();
}
