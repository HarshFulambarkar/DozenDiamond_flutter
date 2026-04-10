// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ReminderRequestModel {
  final String message;
  // final int userId;
  final String scheduledDateTime;
  ReminderRequestModel({
    required this.message,
    //  required this.userId,
    required this.scheduledDateTime,
  });

  ReminderRequestModel copyWith({
    String? message,
    int? userId,
    String? scheduledDateTime,
  }) {
    return ReminderRequestModel(
      message: message ?? this.message,
      //   userId: userId ?? this.userId,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      //   'userId': userId,
      'scheduledDateTime': scheduledDateTime,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['scheduledDateTime'] = this.scheduledDateTime;
    return data;
  }

  factory ReminderRequestModel.fromMap(Map<String, dynamic> map) {
    return ReminderRequestModel(
      message: map['message'] as String,
      //  userId: map['userId'] as int,
      scheduledDateTime: map['scheduledDateTime'] as String,
    );
  }

  // String toJson() => json.encode(toMap());

  factory ReminderRequestModel.fromJson(String source) => ReminderRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ReminderRequestModel(message: $message, scheduledDateTime: $scheduledDateTime)';

  @override
  bool operator ==(covariant ReminderRequestModel other) {
    if (identical(this, other)) return true;

    return
      other.message == message &&
          // other.userId == userId &&
          other.scheduledDateTime == scheduledDateTime;
  }

  @override
  int get hashCode => message.hashCode ^  scheduledDateTime.hashCode;
}