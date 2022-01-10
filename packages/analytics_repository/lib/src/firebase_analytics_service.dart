import 'package:firebase_analytics/firebase_analytics.dart';
import 'analytics_service.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get firebaseAnalytics => _firebaseAnalytics;

  @override
  void logEvent({String? name, Map<String, dynamic>? parameters}) {
    _firebaseAnalytics.logEvent(name: name!, parameters: parameters);
  }
}
