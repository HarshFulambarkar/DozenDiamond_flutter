import 'package:dozen_diamond/subscriptions/models/subscribe_data.dart';

class SubscribeDataResponse {
  bool? status;
  String? message;
  SubscribeData? data;

  SubscribeDataResponse({this.status, this.message, this.data});

  SubscribeDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SubscribeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

