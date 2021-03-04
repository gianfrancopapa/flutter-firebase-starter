abstract class AnalyticsService {
  dynamic getService();
  void logAppOpen();
  void logTutorialBegin();
  void logTutorialComplete();
  void logSignUp(String method);
  void logLogin(String method);
  void logLogout();
  void logEvent({String name, Map parameters});
}
