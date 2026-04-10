import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<String> init() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await _firebaseMessaging.requestPermission();

      final String token = await _firebaseMessaging.getToken() ?? "";
      return token;
    }
    return "";
  }
}
