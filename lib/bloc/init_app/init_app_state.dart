abstract class InitAppState {
  const InitAppState();
}

class InitAppFirstTime extends InitAppState {
  const InitAppFirstTime();
}

class InitAppNotFirstTime extends InitAppState {
  const InitAppNotFirstTime();
}

class InitAppError extends InitAppState {
  final String message;
  const InitAppError(this.message);
}

class InitAppLoadInProgress extends InitAppState {
  const InitAppLoadInProgress();
}

class InitAppInitial extends InitAppState {
  const InitAppInitial();
}
