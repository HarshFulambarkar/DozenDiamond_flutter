import 'package:dozen_diamond/subscriptions/models/subscription_plan_data.dart';

class SubscriptionPlanDataResponse {
  String? message;
  bool? status;
  List<SubscriptionPlanData>? data;

  SubscriptionPlanDataResponse({this.message, this.status, this.data});

  SubscriptionPlanDataResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'].toString();
    status = json['status'];
    if (json['data'] != null) {
      data = <SubscriptionPlanData>[];
      json['data'].forEach((v) {
        data!.add(new SubscriptionPlanData.fromJson(v));
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

