import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';

class LocalNotificationService {
  late FlutterLocalNotificationsPlugin _localNotifications;

  final _didReceivedLocalNotificationSubject =
      BehaviorSubject<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get selected =>
      _didReceivedLocalNotificationSubject.stream;

  // ignore: unused_element
  Function(Map<String, dynamic>) get _onSelected =>
      _didReceivedLocalNotificationSubject.sink.add;

  static final LocalNotificationService _singleton =
      LocalNotificationService._internal();

  factory LocalNotificationService() {
    return _singleton;
  }

  LocalNotificationService._internal() {
    _init();
  }

  Future<void> _init() async {
    _localNotifications = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      await _requestIOSPermission();
    }
    final initializationSettings = _getPlatformSettings();
    await _localNotifications.initialize(
      initializationSettings,
      onSelectNotification: _handleNotificationTap,
    );
  }

  Future _handleNotificationTap(String? payload) async {}

  InitializationSettings _getPlatformSettings() {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    return const InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
  }

  Future<bool?> _requestIOSPermission() async {
    return _localNotifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification(Map<String, dynamic> message) async {
    final notification = message['notification'];
    const androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      channelDescription: 'CHANNEL_DESCRIPTION',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );
    const iosChannelSpecifics = IOSNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
      iOS: iosChannelSpecifics,
    );
    await _localNotifications.show(
      0,
      notification['title'],
      notification['body'],
      platformChannelSpecifics,
      payload: 'payload',
    );
  }

  void close() {
    _didReceivedLocalNotificationSubject.close();
  }
}
