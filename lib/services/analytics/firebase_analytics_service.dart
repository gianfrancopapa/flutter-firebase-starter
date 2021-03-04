import 'package:firebase_analytics/firebase_analytics.dart';

import 'analytics_service.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics();
  FirebaseAnalytics get firebaseAnalytics => _firebaseAnalytics;

  @override
  void logAppOpen() {
    logEvent(name: 'app_open');
  }

  @override
  void logTutorialBegin() {
    logEvent(name: 'tutorial_begin');
  }

  @override
  void logTutorialComplete() {
    logEvent(name: 'tutorial_complete');
  }

  @override
  void logSignUp(String method) {
    logEvent(name: 'signup', parameters: {'method': method});
  }

  @override
  void logLogin(String method) {
    logEvent(name: 'login', parameters: {'method': method});
  }

  @override
  void logLogout() {
    logEvent(name: 'logout');
  }

  @override
  void logEvent({String name, Map parameters}) {
    _firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }

  @override
  dynamic getService() {
    return _firebaseAnalytics;
  }
}
