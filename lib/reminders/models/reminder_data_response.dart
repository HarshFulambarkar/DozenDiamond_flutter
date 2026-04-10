import 'package:dozen_diamond/reminders/models/reminder_data.dart';

class ReminderDataResponse {
  String? message;
  bool? status;
  List<ReminderData>? data;

  ReminderDataResponse({this.message, this.status, this.data});

  ReminderDataResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'].toString();
    status = json['status'];
    if (json['data'] != null) {
      data = <ReminderData>[];
      json['data'].forEach((v) {
        data!.add(new ReminderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReminderUpdateDeleteDataResponse {
  String? message;
  bool? status;
  Map<String, dynamic>? data;

  ReminderUpdateDeleteDataResponse({this.message, this.status, this.data});

  ReminderUpdateDeleteDataResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'].toString();
    status = json['status'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['data'] = this.data;

    return data;
  }
}
