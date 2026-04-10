import 'dart:async';

import 'package:dozen_diamond/global/constants/shared_preferences_manager.dart';
import 'package:dozen_diamond/reminders/services/reminder_api_service.dart';
import 'package:dozen_diamond/global/functions/screenWidthRecoginzer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../ZZZZ_main/mainFile/main.dart';
import '../../global/models/http_api_exception.dart';
import '../../global/models/reminder_response_model.dart';

class ReminderService {
  static final ReminderService _instance = ReminderService._internal();
  factory ReminderService() => _instance;
  ReminderService._internal();

  Timer? _reminderTimer;
  DateTime? _reminderTime; // Format: "HH:mm"

  String? _reminderMessage;

  void start() async {
    await _loadReminderTime();
    _startReminderChecker();
  }

  Future<void> _loadReminderTime() async {
    print("inside _loadReminderTime");
    // final prefs = await SharedPreferences.getInstance();
    // _reminderTime = prefs.getString("reminder_time");
    final dateStr = await SharedPreferenceManager.getReminderTime();
    _reminderMessage = await SharedPreferenceManager.getReminderMessage();
    if (dateStr != null) {
      _reminderTime = DateTime.tryParse(dateStr);
    }
  }

  Future<void> saveReminderDateTime(DateTime dateTime, String message) async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString("reminder_datetime", dateTime.toIso8601String());
    // await prefs.setString("reminder_message", message);

    // _reminderDateTime = dateTime;
    // _message = message;
    // print("inside saveReminderTime");
    // // final prefs = await SharedPreferences.getInstance();
    // // await prefs.setString("reminder_time", time);
    SharedPreferenceManager.saveReminderTime(dateTime.toIso8601String());
    SharedPreferenceManager.saveReminderMessage(message);
    _reminderTime = dateTime;
    _reminderMessage = message;

    scheduleReminder(_reminderMessage ?? "", _reminderTime!);
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<bool> scheduleReminder(
    String reminderMessage,
    DateTime scheduledNotificationDateTime,
    //  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin ,
  ) async {
    try {
      // final androidPlugin = flutterLocalNotificationsPlugin
      //     .resolvePlatformSpecificImplementation<
      //       AndroidFlutterLocalNotificationsPlugin
      //     >();

      // // Request exact alarms (Android 12+ only, safe on Android 8)
      // await androidPlugin?.requestExactAlarmsPermission();

      // print("Scheduling at: $scheduledNotificationDateTime");

      // await flutterLocalNotificationsPlugin.zonedSchedule(
      //   0,
      //   'Reminder',
      //   reminderMessage,
      //   tz.TZDateTime.from(scheduledNotificationDateTime, tz.local),
      //   const NotificationDetails(
      //     android: AndroidNotificationDetails(
      //       'channel_id',
      //       'channel_name',
      //       importance: Importance.high,
      //       priority: Priority.high,
      //       icon: '@drawable/ic_launcher', // FIXED
      //       sound: RawResourceAndroidNotificationSound('notification_sound'),
      //       category: AndroidNotificationCategory.reminder,
      //     ),
      //   ),
      //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      //   // uiLocalNotificationDateInterpretation:
      //   //     UILocalNotificationDateInterpretation.absoluteTime,
      // );
      // await NativeAlarm.scheduleAlarm(
      //   dateTime: scheduledNotificationDateTime,
      //   title: "Reminder!",
      //   message: reminderMessage,
      // );
      // Format WITHOUT milliseconds
      final ist = scheduledNotificationDateTime.toUtc().add(
        const Duration(hours: 5, minutes: 30),
      );
      final formatted =
          "${ist.year.toString().padLeft(4, '0')}-"
          "${ist.month.toString().padLeft(2, '0')}-"
          "${ist.day.toString().padLeft(2, '0')}T"
          "${ist.hour.toString().padLeft(2, '0')}:"
          "${ist.minute.toString().padLeft(2, '0')}:"
          "${ist.second.toString().padLeft(2, '0')}";
      final formattedDateTime = formatted + "+05:30";

      ReminderResponseModel? res = await ReminderRestApiService()
          .setReminderApiService(
            reminderTime: formattedDateTime,
            reminderMessage: reminderMessage,
          );

      if (res.message!.toLowerCase() == "success") {
        // otpResponse = res;
        // Fluttertoast.showToast(msg: res.message ?? "");
        return true;
      } else {
        return false;
      }

      return false;
    } on HttpApiException catch (err) {
      print(err.errorSuggestion);
      print(err.errorTitle);
      print(err.errorCode);
      return false;
    }
  }

  void _startReminderChecker() {
    _reminderTimer?.cancel();
    _reminderTimer = Timer.periodic(Duration(seconds: 20), (timer) {
      if (_reminderTime != null) {
        final now = DateTime.now();

        // Compare to minute precision (date + time)
        if (now.year == _reminderTime!.year &&
            now.month == _reminderTime!.month &&
            now.day == _reminderTime!.day &&
            now.hour == _reminderTime!.hour &&
            now.minute == _reminderTime!.minute) {
          _showReminderDialog();

          // Clear reminder after showing (so it won't repeat)
          //  _clearReminder();
        }
      }
    });

    // print("inside _startReminderChecker");
    // _reminderTimer?.cancel();
    // _reminderTimer = Timer.periodic(Duration(seconds: 30), (timer) {
    //   print("inside _reminderTimer");
    //   if (_reminderTime != null) {
    //     final now = DateTime.now();
    //     final currentTime =
    //         "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    //     print("reminder current time $currentTime");
    //     print(_reminderTime);
    //     if (currentTime == _reminderTime) {
    //       _showReminderDialog();
    //     }
    //   }
    // });
  }

  Future<void> _clearReminder() async {
    SharedPreferenceManager.saveReminderTime("");
    SharedPreferenceManager.saveReminderMessage("");

    _reminderTime = null;
    _reminderMessage = null;
  }

  void _showReminderDialog() {
    print("inside _showReminderDialog");
    // if (globalNavigatorKey.currentContext == null) return;
    print(_reminderTime);
    print(_reminderMessage);
    double screenWidth = screenWidthRecognizer(
      globalNavigatorKey.currentContext ?? Get.context!,
    );

    showDialog(
      barrierDismissible: false,
      context: globalNavigatorKey.currentContext ?? Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: screenWidth - 40,
            padding: const EdgeInsets.only(bottom: 5),
            // width: double.infinity,
            decoration: BoxDecoration(
              color: Color(
                0xFF15181F,
              ), //value.defaultTheme ? Colors.white : Color(0xFF15181F),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white54),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.7,
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                      child: Text(
                        "Reminder",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    bottom: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _reminderMessage ?? "-",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: () async {
                          await _clearReminder();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
