import 'package:intl/intl.dart';

class TimeConverter {
  String convertToISTTime(String utcDateTime) {
    DateTime utcDate = DateTime.tryParse(utcDateTime) ?? DateTime.now();

    DateTime istDate = utcDate.add(Duration(hours: 5, minutes: 30));

    String istTime = "${istDate.hour.toString().padLeft(2, '0')}:"
        "${istDate.minute.toString().padLeft(2, '0')}:"
        "${istDate.second.toString().padLeft(2, '0')}";

    return istTime;
  }

  String convertToISTTimeFormat(String utcDateTime) {
    DateTime utcDate = DateTime.tryParse(utcDateTime) ?? DateTime.now();

    DateTime istDate = utcDate.add(Duration(hours: 5, minutes: 30));

    return DateFormat('hh:mm:ss a').format(istDate);
  }

  String convertToISTTimeFormatDate(DateTime utcDateTime) {
    // DateTime utcDate = DateTime.tryParse(utcDateTime) ?? DateTime.now();

    DateTime istDate = utcDateTime.add(Duration(hours: 5, minutes: 30));

    return DateFormat('dd/MM/yyyy hh:mm a').format(istDate);
  }
}
