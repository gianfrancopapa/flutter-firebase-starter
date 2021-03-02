import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  static final FirebaseAnalytics _instance = FirebaseAnalytics();
  static FirebaseAnalytics get instance => _instance;
}
