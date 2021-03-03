import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebasestarter/services/notifications/local_notification_service.dart';
import 'package:rxdart/subjects.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging();
  final _notificationController = BehaviorSubject<Map<String, dynamic>>();
  final _localNotificationService = LocalNotificationService();

  static final NotificationService _singleton = NotificationService._internal();

  factory NotificationService() {
    return _singleton;
  }

  NotificationService._internal() {
    _configureService();
    _localNotificationService.selected.listen((notification) {
      _onNotificationChanged(notification);
    });
  }

  Stream<Map<String, dynamic>> get notification =>
      _notificationController.stream;

  Function(Map<String, dynamic>) get _onNotificationChanged =>
      _notificationController.sink.add;

  void _configureService() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        await _localNotificationService.showNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _onNotificationChanged(message);
      },
      onResume: (Map<String, dynamic> message) async {
        _onNotificationChanged(message);
      },
    );
  }

  void close() {
    _notificationController.close();
  }
}
