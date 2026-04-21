import 'package:dozen_diamond/reminders/models/reminder_data.dart';
import 'package:dozen_diamond/reminders/models/reminder_data_response.dart';
import 'package:dozen_diamond/reminders/services/reminder_api_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../global/models/http_api_exception.dart';

class ReminderProvider extends ChangeNotifier {
  // ReminderProvider(
  //     this.navigatorKey);

  List<ReminderData> _reminderList = [];

  List<ReminderData> get reminderList => _reminderList;

  set reminderList(List<ReminderData> value) {
    _reminderList = value;
    notifyListeners();
  }

  bool isGettingReminders = false;
  Future<bool> getReminders() async {
    isGettingReminders = true;
    notifyListeners();
    try {
      await Future.delayed(Duration(seconds: 1));
      ReminderDataResponse res = await ReminderRestApiService().getReminders();
      print("getReminders");
      print(res);
      if (res.status == true) {
        _reminderList.clear();
        _reminderList =
            res.data?.where((r) => r.status == "ENQUEUED").toList() ?? [];
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: err.toString());
      return false;
    } finally {
      isGettingReminders = false;
      notifyListeners();
    }
  }

  Future<bool> deleteReminder(int id) async {
    try {
      ReminderUpdateDeleteDataResponse res = await ReminderRestApiService().deleteReminder(
        reminderId: id,
      );
      print("deleteReminder");
      print(res);
      if (res.status == true) {
        await getReminders();
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: err.toString());
      return false;
    }
  }

  Future<bool> updateReminder(int id, DateTime dateTime, String message) async {
    try {
      final ist = dateTime.toUtc().add(const Duration(hours: 5, minutes: 30));
      final formatted =
          "${ist.year.toString().padLeft(4, '0')}-"
          "${ist.month.toString().padLeft(2, '0')}-"
          "${ist.day.toString().padLeft(2, '0')}T"
          "${ist.hour.toString().padLeft(2, '0')}:"
          "${ist.minute.toString().padLeft(2, '0')}:"
          "${ist.second.toString().padLeft(2, '0')}";
      final formattedDateTime = formatted + "+05:30";

      ReminderUpdateDeleteDataResponse res = await ReminderRestApiService().updateReminder(
        reminderId: id,
        reminderTime: formattedDateTime,
        reminderMessage: message,
      );
      print("updateReminder");
      print(res);
      if (res.status == true) {
        await getReminders();
        return true;
      } else {
        return false;
      }
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: err.toString());
      return false;
    }
  }
}
