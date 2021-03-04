import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebasestarter/services/notifications/local_notification_service.dart';
import 'package:rxdart/subjects.dart';

class NotificationService {
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
    FirebaseMessaging.onMessage.listen((event) async {
      await _localNotificationService.showNotification();
    });
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) => _onNotificationChanged(event.data),
    );
    FirebaseMessaging.onBackgroundMessage(
      (message) => _onNotificationChanged(message.data),
    );
  }

  void close() {
    _notificationController.close();
  }
}
