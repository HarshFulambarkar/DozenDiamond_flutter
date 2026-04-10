import 'package:dozen_diamond/global/models/api_request_response.dart';

class PushNotificationResponse implements ApiRequestResponse {
  bool? status;
  String? message;

  PushNotificationResponse({this.status, this.message});

  @override
  PushNotificationResponse fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
