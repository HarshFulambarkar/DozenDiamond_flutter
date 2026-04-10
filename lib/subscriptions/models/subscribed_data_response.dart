import 'package:dozen_diamond/subscriptions/models/subscribed_data.dart';

class SubscribedDataResponse {
  bool? status;
  String? message;
  SubscribedData? data;

  SubscribedDataResponse({this.status, this.message, this.data});

  SubscribedDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SubscribedData.fromJson(json['data']) : null;
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