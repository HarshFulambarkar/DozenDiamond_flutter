class ReminderData {
  int? id;
  String? message;
  String? scheduledTime;
  String? status;
  ReminderData({this.id, this.message, this.scheduledTime, this.status});

  ReminderData.fromJson(Map<String, dynamic> json) {
    id = json['reminder_id'];
    message = json['message'];
    status = json['status'];
    scheduledTime = json['scheduled_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reminder_id'] = this.id;
    data['message'] = this.message;
    data['status'] = this.status;
    data['scheduled_at'] = this.scheduledTime;

    return data;
  }
}
