import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebasestarter/services/notifications/local_notification_service.dart';
import 'package:rxdart/subjects.dart';

class NotificationService {
  final _notificationController = BehaviorSubject<Map<String, dynamic>>();
  //final _localNotificationService = LocalNotificationService();

  Stream<Map<String, dynamic>> get notification =>
      _notificationController.stream;

  Function(Map<String, dynamic>) get onNotificationChanged =>
      _notificationController.sink.add;

  void configure() {
    FirebaseMessaging.onMessage.listen((event) async {
      //await _localNotificationService.showNotification();
    });
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) => onNotificationChanged(event.data),
    );
  }

  void close() {
    _notificationController.close();
  }
}
