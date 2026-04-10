import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

class NotificationProvider with ChangeNotifier {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  List<String> _notifications = [];
  List<String> get notifications => _notifications;

  NotificationProvider() {
    if(kIsWeb == false){
      _initFCM();
    }

  }

  void _initFCM() async {
    print("inside _initFCM");
    // Request notification permissions (iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission for notifications");

      // Get FCM token
      if (Platform.isIOS) {
        _fcmToken = await _firebaseMessaging.getAPNSToken();
        print('📲 APNs Token: $_fcmToken');
      } else {
        _fcmToken = await _firebaseMessaging.getToken();
      }

      print("FCM Token: $_fcmToken");

      SharedPreferenceManager.saveFCMToken(_fcmToken ?? "");

      // Listen for foreground notifications
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Listen for background notifications (When app is opened from notification)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      notifyListeners();
    } else {
      print("User denied notification permissions");
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print("Foreground Notification Received: ${message.notification?.title}");

    _showLocalNotification(message);

    // Add notification to list
    _notifications.add(message.notification?.title ?? "No Title");
    notifyListeners();
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print("Notification Clicked (Background): ${message.notification?.title}");
  }

  void _showLocalNotification(RemoteMessage message) async {
    var androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_launcher_foreground',
    );

    var iosDetails = DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title ?? "New Notification",
      message.notification?.body ?? "Tap to open",
      notificationDetails,
    );
  }
}
