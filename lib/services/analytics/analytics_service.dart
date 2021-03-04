import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics();
  FirebaseAnalytics get firebaseAnalytics => _firebaseAnalytics;

  void logAppOpen() {
    logEvent(name: 'app_open');
  }

  void logTutorialBegin() {
    logEvent(name: 'tutorial_begin');
  }

  void logTutorialComplete() {
    logEvent(name: 'tutorial_complete');
  }

  void logSignUp(String method) {
    logEvent(name: 'signup', parameters: {'method': method});
  }

  void logLogin(String method) {
    logEvent(name: 'login', parameters: {'method': method});
  }

  void logLogout() {
    logEvent(name: 'logout');
  }

  void logEvent({String name, Map parameters}) {
    _firebaseAnalytics.logEvent(name: name, parameters: parameters);
    // Add another analytics service here if required
  }
}
