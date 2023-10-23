import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _handleBgMessage(RemoteMessage? message) async {
  if (message != null) {
    print(message.from);
  }
}


class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

// //create android channel for local notification
   FlutterLocalNotificationsPlugin flutterLocalNotification=FlutterLocalNotificationsPlugin();
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('fcmToken:$fcmToken');
    flutterLocalNotification=FlutterLocalNotificationsPlugin();

    await initializeLocalNotification();
    await initPushNotification();

  }

  void handleMessage(RemoteMessage? message) {
    if (message != null) {
      print(message.from);
    }
  }

  Future<void> initPushNotification() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    await _firebaseMessaging.getInitialMessage().then((value) => handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage;
    });
    FirebaseMessaging.onBackgroundMessage(_handleBgMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification != null) {
        flutterLocalNotification.show(
            1,
            notification.title,
            notification.body,
             const NotificationDetails(
                android: AndroidNotificationDetails(
                  importance: Importance.high,
                    'high_importance_channel','High Importance Channel')),
            payload: jsonEncode(message.toMap()));
      } else {
        return;
      }
    });
  }

  Future initializeLocalNotification() async {
    var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var settings = InitializationSettings(android: initializationSettingsAndroid,iOS:
    initializationSettingsIOS);
    await flutterLocalNotification.initialize(settings,
        onDidReceiveBackgroundNotificationResponse: onTapNotification,
     onDidReceiveNotificationResponse:onTapNotification);

  }
  // on tap local notification in foreground
  static void onTapNotification(NotificationResponse notificationResponse) {
  print('testtt');
  }
}
